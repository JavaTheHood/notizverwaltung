# = User Model
#
# Autor: Roman C. Podolski - podolski@hm.edu, Janek Schoenwetter - schoenwe@hm.edu
class User < ActiveRecord::Base
	# include for profile picture
	include Gravtastic
	gravtastic

  	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :github, :google]

   # associations to other tables - inverse of needed for author and assigend to author
   has_many :notes, inverse_of: :author, foreign_key: :author_id , :class_name => "Note"
   has_many :notes_assigend, inverse_of: :signed_to, foreign_key: :signed_to_id , :class_name => "Note"
   has_many :comments

   # This method will search for an User according to the facebook auth token,
   # if no user is returned by the database, a new one will ne created and returned
   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
     user = User.create(name:auth.extra.raw_info.name,
      provider:auth.provider,
      uid:auth.uid,
      email:auth.info.email,
      password:Devise.friendly_token[0,20]
      )
   end
   user
 end


   # This method will search for an User according to the github auth token,
   # if no user is returned by the database, a new one will ne created and returned
 def self.find_for_github_oauth(auth, signed_in_resource=nil)

  user = User.where(:provider => auth.provider, :uid => auth.id).first
  unless user

    if auth.info.name.nil?
      name = auth.info.nickname
    else
      name = auth.info.name
    end

    user = User.create(
      name: name,
      provider:auth.provider,
      uid:auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0,20]
      )
  end
  user 
end

   # This method will search for an User according to the google-oauth2 auth token,
   # if no user is returned by the database, a new one will ne created and returned
def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
  data = access_token.info
  user = User.where(:email => data["email"]).first

  unless user
    user = User.create(name: data["name"],
     email: data["email"],
     password: Devise.friendly_token[0,20]
     )
  end
  user
end

def self.new_with_session(params, session)
  super.tap do |user|
   if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    user.email = data["email"] if user.email.blank?
  end
end
end

end
