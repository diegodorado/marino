class Store
  include Mongoid::Document
  belongs_to :company, :inverse_of => :stores
  
  field :name

end
