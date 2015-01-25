class ResearchQuestion < ActiveRecord::Base
  extend FriendlyId
  friendly_id :question, use: :slugged
end
