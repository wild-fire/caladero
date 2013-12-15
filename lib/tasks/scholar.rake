namespace :caladero do

  namespace :scholar do

    desc 'Fetching data for all papers from Google Scholar'
    task fetch_all: :environment do
      Paper.all.each do |p|
        p.fetch!
        sleep 1 # We don't want to upset allmighty Google, so we are gonna wait until the next request
      end
    end
  end

end
