# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  ancestry   :string(255)
#  deleted_at :datetime
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_ancestry    (ancestry)
#  index_organizations_on_deleted_at  (deleted_at)
#

class Organization < ActiveRecord::Base
  has_ancestry
  has_many :users

  class << self
    def regional_organization
      regional_ids = Settings.regional_ids
      regional_ids ||= []
      Organization.where(id: regional_ids)
    end
  end



end
