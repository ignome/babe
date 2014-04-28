class Followership < ActiveRecord::Base

  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  #validates :follower, presence: true
  #validates :following, presence: true

  after_save do
    User.increment_counter :following_count, self.follower
    User.increment_counter :followers_count, self.following
  end

  after_destroy do
    User.decrement_counter :following_count, self.follower
    User.decrement_counter :followers_count, self.following
  end
end
