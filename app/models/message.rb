class Message
  include MongoMapper::Document

  key :text, String
  
  userstamps!
  timestamps!

end
