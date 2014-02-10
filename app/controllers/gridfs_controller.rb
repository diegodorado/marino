require 'mongo'
require 'mongoid'

class GridfsController < ActionController::Metal
  def serve
    gridfs_path = env["PATH_INFO"].gsub("/files/", "")
    begin
      uploader = ZipBackupUploader.new
      gridfs_file = CarrierWave::Storage::GridFS::File.new(uploader, uploader.store_path(gridfs_path))
      self.response_body = gridfs_file.read
      self.content_type = gridfs_file.content_type
    rescue Exception => e
      puts e.message
      puts uploader.inspect
      self.status = :file_not_found
      self.content_type = 'text/plain'
      self.response_body = e.message #''
    end
  end
end