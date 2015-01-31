class Author < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :papers
  has_many :coauthors, through: :papers, uniq: true, source: :authors

  def coauthors
    super - [self]
  end

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

    edit do
      field :name
      field :papers
    end

  end
end
