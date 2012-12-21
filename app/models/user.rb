class User
  include MongoMapper::Document
  safe

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  key :email, String
  key :encrypted_password, String

  validates_presence_of :email
  validates_presence_of :encrypted_password
  
  ## Recoverable
  key :reset_password_token, String
  key :reset_password_sent_at, Time

  ## Rememberable
  key :remember_created_at, Time


  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable


  ## Trackable
  key :sign_in_count, Integer
  key :current_sign_in_at, Time
  key :last_sign_in_at, Time
  key :current_sign_in_ip, String
  key :last_sign_in_ip, String
  
  
  

  many :authentications
  many :backups

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end  
  
end
