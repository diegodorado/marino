

class Backup
  include Mongoid::Document
  include Mongoid::Timestamps
  include GridAttachment::Mongoid

  belongs_to :creator, class_name: "User"
  
  attachment :zip, :prefix => :grid
  
end



