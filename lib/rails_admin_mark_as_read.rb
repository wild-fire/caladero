module RailsAdmin
  module Config
    module Actions
      class MarkAsRead < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member? do
          true
        end

        register_instance_option :visible? do
          bindings[:abstract_model].model.to_s == "Paper"
        end

        register_instance_option :link_icon do
          'icon-cloud-upload fa-check-square'
        end

        register_instance_option :controller do
          Proc.new do
            if @object.read?
              @object.mark_as_unread!
            else
              @object.mark_as_read!
            end
            redirect_to back_or_index

          end
        end

      end
    end
  end
end
