class User
  include Mongoid::Document
  rolify
  # Include default devise modules. Others available are:
  #  :encryptable, :lockable, :timeoutable and :omniauthable
  devise :confirmable,
         :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
  has_and_belongs_to_many :audited_companies, :class_name => "Company", :inverse_of => :auditors

  has_and_belongs_to_many :authentications

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end


  def role_enum
    %w[admin backups employee]
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


end
