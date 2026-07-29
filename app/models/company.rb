# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  desc       :text(65535)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Company < ActiveRecord::Base
  has_many :projects
  validates_presence_of :name
end
