# == Schema Information
#
# Table name: competitors
#
#  id         :integer          not null, primary key
#  desc       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Competitor < ActiveRecord::Base
  has_one :attachment, -> {where(model_type: 'competitor')}, class_name: 'Attachment', foreign_key: :model_id
  validates_presence_of :name
  belongs_to :user

  class << self
    def search_conn params
      competitors = self.all
      if params[:table_search].present?
        competitors = competitors.where('name like ?', "%#{params[:table_search]}%")
      end
      competitors
    end
  end

end
