class Backup
  include Mongoid::Document
  include Mongoid::Timestamps
  #attr_accessible :zip, :zip_cache

  belongs_to :creator, class_name: "User", :inverse_of => :backups
  mount_uploader :zip, ZipBackupUploader

end



