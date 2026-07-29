# == Schema Information
#
# Table name: cost_categories
#
#  id         :integer          not null, primary key
#  desc       :text(65535)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CostCategory < ActiveRecord::Base
  validates_presence_of :name
end
