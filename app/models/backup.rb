class Backup
  include MongoMapper::Document
  key :title, String
  key :x, Integer
  #key :y, Integer, :required=> true

  userstamps!
  
  plugin Joint
  attachment :zip
  
end

#Backup.ensure_index([['files_id', Mongo::ASCENDING], ['n', Mongo::ASCENDING]], :unique => true) 
