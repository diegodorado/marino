class Authentication
  include Mongoid::Document
  #safe
  
  field :uid, :type => String
  field :provider, :type => String
  
  has_and_belongs_to_many :user
end
