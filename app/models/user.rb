class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  #  :encryptable, :lockable, :timeoutable and :omniauthable
  devise :token_authenticatable,  :confirmable,
         :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  field :email, :type => String
  field :encrypted_password, :type => String

  validates_presence_of :email
  validates_presence_of :encrypted_password
  ## Recoverable
  field :reset_password_token, :type => String 
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time


  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable


  ## Trackable
  field :sign_in_count, :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String


  field :role, :type => String

  has_many :own_companies, :class_name => "Company", :inverse_of => :owner
  has_and_belongs_to_many :companies, :inverse_of => :users

  has_and_belongs_to_many :authentications
  has_many :backups, :inverse_of => :creator

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end


  def role_enum
    %w[admin employee]
  end

  def role?(role)
    self.role == role.to_s
  end

  def to_label
    email
  end

  def store_ids
    companies.map{|c| c.stores}.flatten.map{|s| s._id}
  end


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

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first

      unless user
          user = User.new(name: data["name"],
  	    		   email: data["email"],
  	    		   password: Devise.friendly_token[0,20]
  	    		  )
      end
      user
  end

end
