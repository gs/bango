namespace :db do
  desc "Fill db with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User", :email => "grechut@gmail.com", :password => "foobar", :password_confirmation => "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      name = Faker::Name.name
      email = "example_#{n+1}@fatbuu.com"
      password = "password"
      User.create!(:name => name, :email => email, :password => password, :password_confirmation => password)
    end

    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end