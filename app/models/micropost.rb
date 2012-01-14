# == Schema Information
#
# Table name: microposts
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user, :presence => true
  validates :content, :presence => true, :length => {:maximum => 140}
  default_scope :order => "created_at DESC"


end

