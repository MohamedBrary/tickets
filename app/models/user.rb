class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  #---- Validations  
  validates :name ,:presence => true
  validates :type ,:presence => true

  #---- Auth Logic
  def policy_class # used by pundit to determine policy, because we have one policy for all subclasses
    UserPolicy
  end

  def self.policy_class # used by pundit to determine policy, because we have one policy for all subclasses
    UserPolicy
  end

  def admin?
  	is_a? Admin
  end

  def customer?
  	is_a? Customer
  end

  def agent?
  	is_a? Agent
  end

  #---- Utils  
  def to_s
  	name
  end
end

class Customer < User
	has_many :tickets, dependent: :destroy	
end

class Agent < User
	has_many :tickets
end

class Admin < User
end