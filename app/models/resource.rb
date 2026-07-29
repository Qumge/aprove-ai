# == Schema Information
#
# Table name: resources
#
#  id         :integer          not null, primary key
#  action     :string(255)
#  deleted_at :datetime
#  name       :string(255)
#  target     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_resources_on_deleted_at  (deleted_at)
#

class Resource < ActiveRecord::Base
  has_and_belongs_to_many :roles, join_table: 'role_resources'
  validates_presence_of :target, :action


    def self.load!
      config = YAML.safe_load_file(Rails.root.join('config/resources.yml'), aliases: false)
    config.each do |target, value|
      value.each do |action, name|
        Resource.find_or_create_by action: action, name: name, target: target
      end
    end
  end

end
