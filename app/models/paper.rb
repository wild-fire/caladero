require 'open-uri'

class Paper < ActiveRecord::Base

  has_and_belongs_to_many :authors

  CSS_PAPER_QUERIES = {
    paper_results: '.gs_ri',
    paper_title: 'h3 a',
    author_names: '.gs_a a',
    year: '.gs_a',
  }
  def obtain_from_google_scholar

    Rails.logger.info "[Scholar] Searching #{self.title} in Scholar"

    doc = Nokogiri::HTML(open("http://scholar.google.es/scholar?q=#{CGI.escape self.title}"))

    paper_result = doc.css(CSS_PAPER_QUERIES[:paper_results]).first

    # we check if we find something
    if paper_result.nil?
      Rails.logger.info "[Scholar] No results for this paper"
      return false
    end


    # We check if we find it in the first result
    paper_title = paper_result.css(CSS_PAPER_QUERIES[:paper_title]).text

    if paper_title != self.title
      Rails.logger.info "[Scholar] This paper was not found"
      return false
    end

    # Now we get the authors and create them if we need it
    author_names = paper_result.css(CSS_PAPER_QUERIES[:author_names])

    Rails.logger.info "[Scholar] Searching authors: #{author_names.text}"

    author_names.each do |author_name|
      author_name = author_name.text
      author = Author.where(name: author_name).first
      author ||= Author.create! name: author_name
      self.authors << author unless self.authors.where(id: author.id).exists?
    end

    # And now the year
    year_text = paper_result.css(CSS_PAPER_QUERIES[:year]).text

    Rails.logger.info "[Scholar] Obtaining year: #{year_text}"
    self.year = year_text.match(/(?<year>\d{4}) - [^-]*$/)[:year]


    self.save!

  end

end
