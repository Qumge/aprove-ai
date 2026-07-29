# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
demo_password = ENV['APROVE_DEMO_PASSWORD'].presence
demo_password ||= 'AproveDemo2026!' unless Rails.env.production?
raise 'APROVE_DEMO_PASSWORD is required in production' if demo_password.blank?

Role.load!
Resource.load!

user = User.find_or_initialize_by(login: 'demo_admin')
user.assign_attributes(
  password: demo_password,
  title: 'Administrator',
  name: 'Demo Admin',
  email: 'demo_admin@example.com'
)
user.save!
user.roles = [Role.find_by!(desc: 'super_admin')]
