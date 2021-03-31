class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable
		 
 #include DeviseTokenAuth::Concerns::User
 devise :omniauthable	 
		 
  validates :email, presence: true, uniqueness: true, on: :create
  validates :password, presence: true, on: :create

  has_many :trips
  has_many :supplies, :through => :trips

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
    end
  end
end
