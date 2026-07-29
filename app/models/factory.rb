# == Schema Information
#
# Table name: factories
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  desc       :text(65535)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Factory < ActiveRecord::Base
  validates_presence_of :name
end
