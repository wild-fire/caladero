require 'open-uri'

class Paper < ActiveRecord::Base

  has_and_belongs_to_many :authors
  belongs_to :category

  CSS_PAPER_QUERIES = {
    paper_results: '.gs_r',
    paper_title: 'h3 a',
    author_names: '.gs_a a',
    year: '.gs_a',
    quotes: '.gs_ri .gs_fl a',
    paper_url: '.gs_ggs.gs_fl a'
  }

  extend Enumerize
  enumerize :priority, in: { must_read: 3, interesting: 2, not_so_interesting: 1, discarded: 0}

  def obtain_from_google_scholar

    Rails.logger.info "[Scholar] Searching #{self.title} in Scholar"

    doc = Nokogiri::HTML(open("http://scholar.google.es/scholar?hl=en&q=#{CGI.escape self.title}"))

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

    # And now the number of quotes
    quotes_text = paper_result.css(CSS_PAPER_QUERIES[:quotes]).first.text
    Rails.logger.info "[Scholar] Obtaining quotes: #{quotes_text}"
    self.quotes_count = quotes_text.match(/ \d*$/).to_s.strip

    # And now a link to the paper
    paper_link = paper_result.css(CSS_PAPER_QUERIES[:paper_url]).first
    Rails.logger.info "[Scholar] Obtaining URL: #{paper_link}"
    self.paper_url ||= paper_link[:href] # If we had a url we don't need a new one

    self.save!

  end

end
