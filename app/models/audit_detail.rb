# == Schema Information
#
# Table name: audit_details
#
#  id         :integer          not null, primary key
#  audit_id   :integer
#  status     :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuditDetail < ActiveRecord::Base
end
