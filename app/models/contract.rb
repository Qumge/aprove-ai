# == Schema Information
#
# Table name: contracts
#
#  id              :integer          not null, primary key
#  advance_time    :integer
#  cycle           :string(255)
#  deleted_at      :datetime
#  name            :string(255)
#  no              :string(255)
#  others          :text(65535)
#  partner         :string(255)
#  process_time    :integer
#  product         :string(255)
#  settlement_time :integer
#  tail_time       :integer
#  valid_date      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_contracts_on_deleted_at  (deleted_at)
#

class Contract < ActiveRecord::Base
  validates_presence_of :name, :no, :partner, :product
  validates_uniqueness_of :no
  validates_numericality_of :advance_time, if: Proc.new{|p| p.advance_time.present?}
  validates_numericality_of :process_time, if: Proc.new{|p| p.process_time.present?}
  validates_numericality_of :settlement_time, if: Proc.new{|p| p.settlement_time.present?}
  validates_numericality_of :tail_time, if: Proc.new{|p| p.tail_time.present?}
  has_many :sales
  has_one :project
  has_and_belongs_to_many :projects, join_table: "projects_contracts"


  class << self
    def search_conn params
    contracts = self.all
      if params[:table_search].present?
        contracts = contracts.where('contracts.name like ? or contracts.partner like ? or contracts.no like ? ', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      contracts
    end
  end
end
