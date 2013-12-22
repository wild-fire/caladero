require 'net/http'

class Paper < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, use: :slugged

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
  enumerize :priority, { in: { must_read: 3, interesting: 2, not_so_interesting: 1, discarded: 0 }, scope: :prioritized_as }

  before_save :calculate_score

  def calculate_score
    self.score = (self.quotes_count || 1) / (Date.today.year - self.year + 1).to_f unless self.quotes_count.nil? || self.year.nil?
  end

  after_save :check_category_score

  def check_category_score
    self.category.update_attribute :score, [self.score, self.category.score].max unless self.category.nil?
  end

  def fetch!

    Rails.logger.info "[Scholar] Searching #{self.title} in Scholar"

    url = "http://scholar.google.es/scholar?hl=en&q=#{CGI.escape self.title}"

    Rails.logger.info "[Scholar] Downloading #{url}"

    http = Net::HTTP.new("scholar.google.com", 80)
    req = Net::HTTP::Get.new("/scholar?hl=en&q=#{CGI.escape self.title}&btnG=&lr=", {'Referer' => 'http://scholar.google.com', 'User-Agent' => 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.35 Safari/537.17'})
    response = http.request(req)

    Rails.logger.info "[Scholar] HTML DOwnloaded: #{response.body}"

    doc = Nokogiri::HTML(response.body)

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

    Rails.logger.info "[Scholar] Obtaining authors: #{author_names.text}"

    author_names.each do |author_name|
      author_name = author_name.text
      author = Author.where(name: author_name).first
      author ||= Author.create! name: author_name
      self.authors << author unless self.authors.where(id: author.id).exists?
    end

    # And now the year
    year_text = paper_result.css(CSS_PAPER_QUERIES[:year]).text

    Rails.logger.info "[Scholar] Obtaining year: #{year_text}"
    self.year = year_text.match(/(?<year>\d{4}) - .*$/)[:year]

    # And now the number of quotes
    quotes_text = paper_result.css(CSS_PAPER_QUERIES[:quotes]).first.text
    Rails.logger.info "[Scholar] Obtaining quotes: #{quotes_text}"
    self.quotes_count = quotes_text.match(/ \d*$/).to_s.strip

    # And now a link to the paper
    paper_link = paper_result.css(CSS_PAPER_QUERIES[:paper_url]).first
    Rails.logger.info "[Scholar] Obtaining URL: #{paper_link}"
    self.paper_url ||= paper_link[:href] unless paper_link.nil? # If we had a url we don't need a new one

    self.save

  end

end
