class CropPrice
  include MongoMapper::Document

  key :month, String
  key :price, Integer

  userstamps!

  belongs_to :crop


end
