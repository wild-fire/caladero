class Category < ActiveRecord::Base
  has_many :papers
end
