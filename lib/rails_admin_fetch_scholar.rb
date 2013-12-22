module RailsAdmin
  module Config
    module Actions
      class FetchScholar < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member? do
          true
        end

        register_instance_option :visible? do
          bindings[:abstract_model].model.to_s == "Paper"
        end

        register_instance_option :link_icon do
          'icon-cloud-download fa-cloud-download'
        end

        register_instance_option :controller do
          Proc.new do
            if @object.fetch!
              flash[:success] = "Information about #{@object.title} has been fetched from Google Scholar"
            else
              flash[:warning] = "Information about #{@object.title} couldn't be fetched from Google Scholar"
            end
            redirect_to back_or_index
          end
        end

      end
    end
  end
end
