# == Schema Information
#
# Table name: user_roles
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  role_id    :integer
#  user_id    :integer
#

class UserRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
end
