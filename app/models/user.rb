class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name ,:presence => true
  validates :type ,:presence => true
end

class Customer < User
	has_many :tickets	
end

class Agent < User
	has_many :tickets
end

class Admin < User
end