module AfipService
  
  class Auth
  
    def auth_param
      {'Auth'=>{
        'Cuit' => APP_CONFIG['cuit'],
        'Sign' => credentials['sign'],
        'Token' => credentials['token']  
      }}
    end
    
    private 

    @credentials = nil

    def logger
      AfipService::Logger  
    end
  
    
    def credentials
      @credentials = cached unless @credentials 
      @credentials = request if expired?
      @credentials
    end
  
    def ticket_request
      logger.info "Generating Ticket Request"
      xml = File.read(::Rails.root.to_s + '/config/wsafip/ltr_blueprint.xml')
      puts 'ticket_request'
      puts xml % [DateTime.now.to_i, (DateTime.now-0.25).to_s, (DateTime.now+0.25).to_s]
      xml % [DateTime.now.to_i, (DateTime.now-0.25).to_s, (DateTime.now+0.25).to_s]
    end
  
    def signed_ticket_request
      logger.info "Signing Ticket Request"
      key = OpenSSL::PKey::RSA.new(File.read(::Rails.root.to_s + APP_CONFIG['key']))
      crt = OpenSSL::X509::Certificate.new(File.read(::Rails.root.to_s + APP_CONFIG['crt']))      
      signed = OpenSSL::PKCS7::sign( crt,key , ticket_request)
      puts signed.to_s.gsub(/-----.*PKCS7-----/, '')
      puts 'signed_ticket_request'
      signed.to_s.gsub(/-----.*PKCS7-----/, '')
    end    
  
    def request
      logger.info "Requesting credentials to WSAA"
      client = Savon::Client.new do
        wsdl.document = ::Rails.root.to_s + APP_CONFIG['wsaa_wsdl']
      end
      
      begin
        response = client.request :login_cms do
          soap.body = { 'in0' => signed_ticket_request }
        end
     
        ta = Hash.new
        doc = Hpricot::XML(CGI.unescapeHTML(response.http.body))
        ['expirationTime','token','sign'].each{|k| ta[k] = doc.search(k).inner_html}
        logger.info "Persisting credentials to #{cached_file}"
        File.open( cached_file , "w") {|f| f.write(ta.to_yaml) }
        return ta
        
      rescue Savon::Error => error
        logger.error "Error getting credentials to WSAA"
        logger.error error.to_s
      end
    end
  
    def cached
      logger.info "Getting cached credentials from /tmp/ta.yml"
      YAML.load_file(cached_file) if File.exists?(cached_file)
    end

    def cached_file
      "#{::Rails.root.to_s}/tmp/ta.yml"
    end

  
    def expired?
      logger.info "Check if credentials have expired"
      return true if @credentials.nil? 
      (DateTime.parse(@credentials['expirationTime'])- DateTime.now - 1/24.0 ) < 0
    end
  
  
  end
  
end
