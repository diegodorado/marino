#todo: what is private and what public?
#todo:avoid editing if got cae

class Invoice < ActiveRecord::Base
  belongs_to :delivery_slip
  belongs_to :customer
  belongs_to :currency
  has_many :invoice_items, :dependent => :destroy
  has_many :invoice_taxes, :dependent => :destroy
  accepts_nested_attributes_for :invoice_items
  accepts_nested_attributes_for :invoice_taxes
  acts_as_searchable :doc_no
  after_initialize :defaults

  def defaults
    #fixme: only for new records!!
    return unless self.new_record?
    self.delivery_slip_id ||= 1
    self.invoice_type ||= 1
    self.pos ||= 1
    self.currency_id ||= 1
    self.currency_rate ||= 1
    #to avoid the setters behaviour uppon uninitialized values??
    [:untaxed_amount, :taxed_amount,:exempt_amount,:taxes_amount,:iva_amount,:total_amount].each do |column|
      self[column] ||= 0
    end
    self.date ||= Date.today
    #todo: save due_days on config
    self.due_date ||= 15.days.since(date)
    #add iva 21% by default
    #self.add_tax(1)
  end

  def get_next_doc_no
    #todo: get from db if available first
    return unless invoice_type && pos
    last = AfipService::Wsfe.get_last_authorized(invoice_type,pos)
    self.doc_no = last + 1 if last
  end

=begin
  #update total_amount on any amount change
  #and fix it to 2 decimal places
  [:untaxed_amount,:exempt_amount,:taxes_amount,:iva_amount].each do |column|
    class_eval <<-METHOD
      def #{column}=(v)
        write_attribute(:#{column}, v.to_f.round(2))
        write_attribute(:total_amount, taxes_amount + exempt_amount + taxed_amount + untaxed_amount + iva_amount)
      end
    METHOD
  end

  #fix it to 3 decimal places
  def currency_rate=(v)
    write_attribute(:currency_rate, v.to_f.round(3))
  end

  def taxed_amount=(v)
    #since taxed_amount changes, invoice_taxes.tax_base, and iva_amount also have to
    write_attribute(:taxed_amount, Float(v).round(2))
    #r = 0
    #self.invoice_taxes.map do |it|
    #  it.tax_base = Float(v).round(2)
    #  r += it.tax_amount
    #end
    #do not 'write_attribute', so behaviour changes total_amount also
    self.iva_amount = (v.to_f*0.21).round(2)
  end

  def add_tax(tax_id)
    self.invoice_taxes.clear
    it = self.invoice_taxes.build({:tax_id => tax_id})
    it.tax_base = self.taxed_amount
    self.iva_amount = it.tax_amount
  end  
=end

=begin
  def build_from_delivery_slip(ds)
    self.delivery_slip_id = ds.id
    self.customer_id = ds.customer_id
    self.currency_id = ds.delivery_order.currency_id
    
    unless self.currency_id == 1
      cr = CurrencyRate.find_by_currency_id_and_date(self.currency_id,self.date)
      self.currency_rate = cr.rate if cr
    end

    unit_prices_by_product = ds.delivery_order.delivery_order_items.maximum(:unit_price,:group=>:product_id)
 
    ds.delivery_slip_items.map do |dsi|
      ii = self.invoice_items.build(dsi.attributes.select {|v| ['product_id','description','qty'].include?(v) })
      ii.unit_price = unit_prices_by_product[ii.product_id]
      ii.price = (ii.qty * ii.unit_price * self.currency_rate).round(2)
    end
    self.total = (self.subtotal + self.iva).round(2)
    self
  end
=end

  def afip_request

      det_request = {
                    'Concepto'=>1, #01 - productos
                    'DocTipo'=>80, #80 - cuit
                    'DocNro'=>customer.cuit,
                    'CbteDesde'=>doc_no,
                    'CbteHasta'=>doc_no,
                    'CbteFch'=>date.strftime('%Y%m%d'),
                    'ImpTotal'=>total_amount,#Importe neto no gravado + Importe exento + Importe neto gravado + todos los campos de IVA al XX% + Importe de tributos
                    'ImpTotConc'=>untaxed_amount,#Importe neto no gravado.
                    'ImpNeto'=>taxed_amount,#Importe neto gravado.
                    'ImpOpEx'=>exempt_amount,#Importe exento
                    'ImpTrib'=>taxes_amount,#Suma de los importes del array de Tributos
                    'ImpIVA'=>iva_amount,#Suma de los importes del array de IVA
                    'MonId'=>currency.afip_code,
                    'MonCotiz'=>currency_rate, #Para PES, pesos argentinos la misma debe ser 1
                  }

      #invoice_taxes.map do |t|
      #  det_request['Iva'] = {'AlicIva'=>{'Id'=>t.tax.afip_code,'BaseImp'=>t.tax_base.round(2),'Importe'=>t.tax_amount.round(2)}}
      #end                  
      det_request['Iva'] = {'AlicIva'=>{'Id'=>5,'BaseImp'=>taxed_amount,'Importe'=>iva_amount}}

      {'FeCAEReq'=>
        {'FeCabReq'=> {'CantReg'=>1,'PtoVta'=>pos,'CbteTipo'=>invoice_type},
          'FeDetReq'=>  {'FECAEDetRequest'=> det_request}
        }}
  
  end

  def update_delivery_slip
    #todo: mark delivery_slip as invoiced
  end
  
  def save
    if super 
      self.update_delivery_slip
      true
    end
  end

  def barcode
    #a. Clave Única de Identificación Tributaria (C.U.I.T.) del emisor de la factura .
    code = APP_CONFIG['cuit']
    #b. Código de tipo de comprobante (2 caracteres).
    code << "%02d" % invoice_type
    #c. Punto de venta (4 caracteres).
    code << "%04d" % doc_no
    #d. Código de Autorización de Impresión (C.A.I.) (14 caracteres).
    code << cae
    #e. Fecha de vencimiento (8 caracteres).
    code << date.strftime('%Y%m%d')
    #f. Dígito verificador (1 carácter).
    code << digito_verificador(code)
    code
  end
  
  def digito_verificador(codigo)
    #"Rutina para el cálculo del dígito verificador 'módulo 10'"
    # http://www.consejo.org.ar/Bib_elect/diciembre04_CT/documentos/rafip1702.htm
    # comenzar desde la izquierda, sumar todos los caracteres ubicados en las posiciones impares.
    impares = codigo.each_char.inject(0){|memo,c| memo + (c.to_i % 2 ==1? c.to_i : 0)}
    # comenzar desde la izquierda, sumar todos los caracteres que están ubicados en las posiciones pares.
    pares = codigo.each_char.inject(0){|memo,c| memo + (c.to_i % 2 ==0? c.to_i : 0)}
    # sumar los resultados obtenidos en las etapas 2 y 3.
    total = impares*3 + pares
    # Etapa 5: buscar el menor número que sumado al resultado obtenido en la etapa 4 dé un número múltiplo de 10. Este será el valor del dígito verificador del módulo 10.
    (total % 10 > 0 ? 10 - total % 10 : 0).to_s
  end  
  
end
