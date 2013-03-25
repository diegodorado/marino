class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slugify
  belongs_to :owner, :class_name => "User", :inverse_of => :own_companies
  has_and_belongs_to_many :users, :class_name => "User", :inverse_of => :companies
  has_many :stores, :inverse_of => :company
  
  field :name

  private
  def generate_slug
    name.parameterize
  end  

end
