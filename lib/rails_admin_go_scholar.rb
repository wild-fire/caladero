module RailsAdmin
  module Config
    module Actions
      class GoScholar < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member? do
          true
        end

        register_instance_option :visible? do
          bindings[:abstract_model].model.to_s == "Paper"
        end

        register_instance_option :link_icon do
          'icon-cloud-upload fa-cloud-upload'
        end

        register_instance_option :controller do
          Proc.new do
            redirect_to "http://scholar.google.com//scholar?hl=en&q=#{CGI.escape @object.title}&btnG=&lr="
          end
        end

      end
    end
  end
end
