# == Schema Information
#
# Table name: costs
#
#  id               :integer          not null, primary key
#  amount           :float(24)
#  occur_time       :datetime
#  purpose          :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cost_category_id :integer
#  user_id          :integer
#

class Cost < ActiveRecord::Base
  belongs_to :user
  belongs_to :cost_category
  validates_presence_of :amount, :purpose, :user_id, :occur_time, :cost_category_id

  class << self
    # 检索
    def search_conn params
      costs = self.all
      if params[:table_search].present?
        costs = costs.joins(:user).where('users.name like ?', "%#{params[:table_search]}%")
      end
      costs
    end
  end

end
