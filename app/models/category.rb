# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base
  has_many :projects
  validates_presence_of :name
  CATEGORY = ['地产', '酒店', '其他']


  class << self
    def load!
      CATEGORY.each do |category|
        self.find_or_create_by name: category
      end
    end
  end
end
