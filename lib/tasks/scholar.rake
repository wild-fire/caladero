namespace :caladero do

  namespace :scholar do

    desc 'Fetching data for all papers from Google Scholar'
    task fetch: :environment do
      papers = ENV["ALL"].nil? ? Paper.where(quotes_count: nil) : Paper.all
      papers.each do |p|
        puts "[Scholar] Searching #{p.title}"
        p.fetch!
        sleep 5 # We don't want to upset allmighty Google, so we are gonna wait until the next request
      end
    end
  end

end
