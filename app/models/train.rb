# == Schema Information
#
# Table name: trains
#
#  id          :integer          not null, primary key
#  action_type :string(255)
#  desc        :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Train < ActiveRecord::Base
  has_one :attachment, -> {where(model_type: 'train')}, class_name: 'Attachment', foreign_key: :model_id
  belongs_to :user
  validates_presence_of :name

  class << self
    def search_conn params
      trains = self.all
      if params[:table_search].present?
        trains = trains.where('trains.name like ?', "%#{params[:table_search]}%")
      end
      trains
    end
  end

end
