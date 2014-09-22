module AfipService

  class Wsfe    


    #:fecaea_reg_informativo
    #<FeCAEARegInfReq>
    #  <FeCabReq />
    #  <FeDetReq>
    #    <FECAEADetRequest>
    #      <CAEA>string</CAEA>
    #    </FECAEADetRequest>
    #    <FECAEADetRequest>
    #      <CAEA>string</CAEA>
    #    </FECAEADetRequest>
    #  </FeDetReq>
    #</FeCAEARegInfReq>
        
    #:fecaea_solicitar
    #<Periodo>int</Periodo>
    #<Orden>short</Orden>
    
    #:fecaea_sin_movimiento_consultar
    #<CAEA>string</CAEA>
    #<PtoVta>int</PtoVta>    
    
    #:fecaea_sin_movimiento_informar
    #<PtoVta>int</PtoVta>
    #<CAEA>string</CAEA>
        
    #:fecaea_consultar
    #<Periodo>int</Periodo>
    #<Orden>short</Orden>
    
    
  
    def self.dummy
      client = Savon::Client.new do
        wsdl.document = ::Rails.root.to_s + APP_CONFIG['wsfe_wsdl']
      end
      response = client.request :fe_dummy
      response.to_hash.first[1].first[1]
    end
  
    def self.get_soap_actions
      client = Savon::Client.new do
        wsdl.document = ::Rails.root.to_s + APP_CONFIG['wsfe_wsdl']
      end
      client.wsdl.soap_actions
    end
    
    # Calls *:fe_comp_ultimo_autorizado* on WSFE
    #[+pto_vta+] required
    #[+cbte_tipo+] required
    def self.get_last_authorized(type, pos)
      result = self.invoke :fe_comp_ultimo_autorizado, {"CbteTipo"=> type, "PtoVta"=> pos}
      #removes data wrappers
      result[:cbte_nro].to_i if result
    end

    ## Returns WSFE types for
    #  :fe_param_get_tipos_tributos
    #  :fe_param_get_tipos_monedas
    #  :fe_param_get_tipos_iva
    #  :fe_param_get_tipos_opcional
    #  :fe_param_get_tipos_concepto
    #  :fe_param_get_tipos_cbte
    #  :fe_param_get_tipos_doc 
    #[+t+] must be one of the followings: +:tributos,:monedas,:iva,:opcional,:concepto,:cbte,:doc+
    #  it also caches the result for further reading
    def self.get_types(t)
      return nil unless [:tributos,:monedas,:iva,:opcional,:concepto,:cbte,:doc].include?(t)
      
      method_str = 'fe_param_get_tipos_' << t.to_s 
      cached_file = "#{::Rails.root.to_s}/tmp/#{method_str}.yml"
      return YAML.load_file(cached_file) if File.exists?(cached_file)
      
      result = self.invoke method_str.to_sym
      if result
        #removes data wrappers and innecesary date values
        #returns a hash of +id+ and +desc+
        h = {}
        result.first[1].first[1].collect{|i| h[i[:id]]=i[:desc]}
        File.open( cached_file , "w") {|f| f.write(h.to_yaml) }
        h
      end
    end

    # Calls *:fe_param_get_cotizacion* on WSFE
    #[+currency_id+] required
    def self.currency_rate(currency_id)
      result = self.invoke :fe_param_get_cotizacion, {'MonId'=>currency_id}
      #removes data wrappers
      result.first[1]
    end

    # Calls *:fe_comp_tot_x_request* on WSFE
    def self.max_invoices_per_request
      result = self.invoke :fe_comp_tot_x_request
      #removes data wrappers
      result.first[1].first[1].to_i if result
    end

    # Calls *:fe_param_get_ptos_venta* on WSFE
    def self.points_of_sale
      result = self.invoke :fe_param_get_ptos_venta
      #removes data wrappers
      result.first[1]
    end

    #:fecae_solicitar
    def self.request_cae(params)
      result = self.invoke_raw :fecae_solicitar, params
    end

    ## Calls WSFE on :fe_comp_consultar
    def self.get_cae(invoice_type, pos, doc_no)
      result = self.invoke :fe_comp_consultar, {'FeCompConsReq'=>{'CbteTipo'=> invoice_type,
                                                                  'PtoVta'=>pos,
                                                                  'CbteNro'=> doc_no}}
      result
    end




    
    private 

      def self.logger
        AfipService::Logger  
      end
    
      def self.invoke_raw(method, params={})
        #error handling will be here
        client = Savon::Client.new do
          wsdl.document = ::Rails.root.to_s + APP_CONFIG['wsfe_wsdl']
        end
        a = AfipService::Auth.new 
        response = client.request :soap, method do
          soap.body = params.merge(a.auth_param)
        end
        response.to_hash rescue {}
      end

      def self.invoke(method, params={})
        response = self.invoke_raw method, params
        result = response.to_hash.first[1].first[1]
        logger.info response.to_hash
        if result.has_key?(:errors)
          puts "Hubieron errores"
          puts result[:errors].first[1]
          return nil
        else
          result
        end
      end
      
  end
end
