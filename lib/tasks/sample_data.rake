require 'faker'

namespace :db do
  desc "Fill db with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Example User", :email => "sfistak@fatbuu.com", :password => "foobar", :password_confirmation => "foobar")
    99.times do |n|
      name = Faker::Name.name
      email = "example_#{n+1}@fatbuu.com"
      password = "password"
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
    end
  end
end