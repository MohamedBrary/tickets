class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  #---- Validations & Callbacks
  validates :name ,:presence => true
  validates :type ,:presence => true

  after_save :check_password_changed
  def check_password_changed
    if changed.include?('encrypted_password') && (self.changed_password == false)
      self.changed_password = true 
      self.save(validate: false) #skip further validations
    end
  end

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
  def validate_not_customer
    errors.add(:type, "Customer can't be created, he/she should only signup") if type == "Customer"
  end

  def generate_confirmation_token
    self.confirmation_token = Devise.friendly_token
    self.confirmation_sent_at = Time.now.utc
  end

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