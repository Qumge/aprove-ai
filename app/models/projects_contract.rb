# == Schema Information
#
# Table name: projects_contracts
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  contract_id :integer
#  project_id  :integer
#

class ProjectsContract < ActiveRecord::Base
end
