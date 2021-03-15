require 'mailchimp'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  acts_as_voter

  after_create :add_user_to_mailchimp

  def add_user_to_mailchimp
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    mailchimp.lists.subscribe(ENV['MAILCHIMP_LIST_ID'], 
                   { "email" => self.email,
                     "euid" => self.id,
                     "leid" => "#{self.id}-7698cc9b01",
                   })
  end
end
