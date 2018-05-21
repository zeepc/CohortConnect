# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[linkedin]

  has_many :cohort_users
  has_many :cohorts, through: :cohort_users

  has_many :group_invitations

  
  def from_omniauth(auth)
    
    self.email = auth.info.email
    self.provider = auth.provider
    self.uid = auth.uid
    self.first_name = auth.info.first_name   # assuming the self model has a name
    self.last_name = auth.info.last_name # assuming the self model has an image
    self.profile_image_link = auth.info.image
    self.profile_link = auth.info.urls.public_profile
    self.location = auth.info.location.name
    self.summary = auth.extra.raw_info.summary

    if auth.extra.raw_info.positions.length > 1
      self.current_employer = auth.extra.raw_info.positions.values[1][0].company.name
      self.current_title = auth.extra.raw_info.positions.values[1][0].title
    end

    if !self.password
      self.password = Devise.friendly_token[0,20]
    end 

    
    # puts "%%%%%%%%"
    # # puts JSON.pretty_generate(auth.extra.raw_info.positions.values[1][0])
    # puts JSON.pretty_generate(auth)
    return self

    # If you are using confirmable and the provider(s) you use validate emails, 
    # uncomment the line below to skip the confirmation emails.
    # user.skip_confirmation!  
  end
end
