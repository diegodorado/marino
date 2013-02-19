class Backup
  include MongoMapper::Document

  userstamps!
  timestamps!
  
  plugin Joint
  attachment :zip
  
end



