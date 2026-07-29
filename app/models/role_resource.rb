# == Schema Information
#
# Table name: role_resources
#
#  id          :integer          not null, primary key
#  role_id     :integer
#  resource_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class RoleResource < ActiveRecord::Base
  belongs_to :role
  belongs_to :resource
  class << self
    def load!
      config = YAML.load_file("#{Rails.root}/config/role_resources.yml")
      config.each do |role_desc, value|
        role = Role.find_by desc: role_desc
        if role.present?
          value.each do |target, resources|
            resources.each do |resource_action, resource_name|
              resource = Resource.find_by action: resource_action, target: target
              # p role.name, resource.action, resource.name
              RoleResource.find_or_create_by role: role, resource: resource if resource.present?
            end
          end
        end
      end
    end
  end
end
