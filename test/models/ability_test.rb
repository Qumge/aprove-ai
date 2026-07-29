require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test 'loads database-backed permissions without evaluating code' do
    user = users(:one)
    role = Role.create!(name: 'Report Reader', desc: 'report_reader')
    resource = Resource.create!(action: 'index', target: 'record_reports', name: 'Reports')
    role.resources << resource
    user.roles << role

    assert Ability.new(user).can?(:index, :record_reports)
  end
end
