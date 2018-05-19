# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[linkedin]

  has_many :cohort_users
  has_many :cohorts, through: :cohort_users

  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name   # assuming the user model has a name
      user.last_name = auth.info.last_name # assuming the user model has an image
      user.profile_image_link = auth.info.image
      user.profile_link = auth.info.urls.public_profile
      user.location = auth.info.location.name
      user.summary = auth.extra.raw_info.summary
      user.current_employer = auth.extra.raw_info.positions.values[1][0].company.name
      user.current_title = auth.extra.raw_info.positions.values[1][0].title
      # puts "%%%%%%%%"
      # puts JSON.pretty_generate(auth.extra.raw_info.positions.values[1][0])
      # puts JSON.pretty_generate(auth)

      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
      
    end
  end
end
