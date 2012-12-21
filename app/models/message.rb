class Message
  include MongoMapper::Document

  key :text, String
  
  plugin Joint
  attachment :zip

  userstamps!
  

end
