# == Schema Information
#
# Table name: reports
#
#  id            :integer          not null, primary key
#  address       :string(255)
#  builder       :string(255)
#  desc          :string(255)
#  name          :string(255)
#  phone         :string(255)
#  product       :string(255)
#  project_step  :string(255)
#  project_type  :string(255)
#  purchase_type :string(255)
#  scale         :string(255)
#  source        :string(255)
#  supply_time   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :integer
#  user_id       :integer
#

class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :project_id, :name, :address, :builder

end
