class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :items
  has_many :styles
  has_many :photos
  has_many :comments
  has_many :topics
  
  has_many :followerships, foreign_key: 'following_id'
  has_many :followers, :through => :followerships, :source => :follower

  has_many :followingships, foreign_key: 'follower_id', class_name: 'Followership'
  has_many :following, :through => :followingships, :source => :following
  
  has_many :fans_of_items
  has_many :likes, :through => :fans_of_items, :source => :item

  validates :login, :format => {:with => /\A\w+\z/, :message => '只允许数字、大小写字母和下划线'}, :length => {:in => 3..20}, :presence => true, :uniqueness => {:case_sensitive => false}

  mount_uploader :avatar, AvatarUploader

  def followed user
    Followership.where(follower_id: self.id, following_id: user.id)
  end

end
