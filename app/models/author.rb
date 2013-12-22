class Author < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_and_belongs_to_many :papers
  has_many :coauthors, through: :papers, uniq: true, source: :authors

  def coauthors
    super - [self]
  end
end
