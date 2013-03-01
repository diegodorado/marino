class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :owner, class_name: "User"
  
  embeds_many :crop_controls
  accepts_nested_attributes_for :crop_controls

  field :name
  

end

class CropControl
  include Mongoid::Document
  include Mongoid::Timestamps
  embedded_in :company, :inverse_of => :crop_controls
  
  field :name
end


