namespace :caladero do

  namespace :import do

    desc 'Imports papers from a markdwon document'
    # Markdown document format is quite simple:
    # ## Category
    # ### Paper
    # [Download](paper url)
    # Description
    # ### Paper
    # [Download](paper url)
    # Description
    # ### Paper
    # [Download](paper url)
    # Description
    # ## Category
    # ### Paper
    # [Download](paper url)
    # Description
    task markdown: :environment do

      # We open the file
      file = File.new(ENV["FILE"] || "#{Rails.root}/db/fixtures/example")
      paper = nil

      file.each_line do |line|
        line.strip!

        case
        when line.starts_with?('###') # Here we have the paper title
          Rails.logger.info ("[Import] Title #{line}")
          paper.save unless paper.nil? # It's a new paper so we save the previous one

          paper_title = line.gsub('###', '').strip # We delete the #s and any space
          paper = Paper.where(title: paper_title).first
          paper ||= Paper.new title: paper_title, description: ''
        when line.starts_with?('##') # Here we have the paper category
          Rails.logger.info ("[Import] Category #{line}")
          # We don't play with this, yet
        when line.starts_with?('[') # Here we have the paper url
          Rails.logger.info ("[Import] URL #{line}")
          paper.paper_url = line.match(/\((?<url>.*)\)$/)[:url] # We only get the url
        when !line.blank? # Here we have the paper description
          Rails.logger.info ("[Import] Description #{line}")
          paper.description += "#{line}\n"
        else
          Rails.logger.info ("[Import] Nothing #{line}")
        end
      end

      paper.save unless paper.nil?

    end

  end

end
