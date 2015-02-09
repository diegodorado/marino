class Store
  include Mongoid::Document
  belongs_to :company, :inverse_of => :stores
  has_many :crop_controls, dependent: :restrict
  field :name
  field :marketing_costs, :type => Array

end
