Factory.define :user do |user|
  user.name                  "Adam Asny"
  user.email                 "adam@fatbuu.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@fatbuu.com"
end