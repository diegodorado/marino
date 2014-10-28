module AfipService
  class Logger
    #wrapper to do logging in console also
    def self.method_missing(method, *args)
      Rails.logger.__send__ method, *args
      puts args[0]
    end    
  end  
end
