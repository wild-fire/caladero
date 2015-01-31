class Category < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :papers

  rails_admin do

    list do
      sort_by :name
      field :name
      field :papers do
        pretty_value do
           bindings[:object].papers.count
        end
      end
    end

  end

end
