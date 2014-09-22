class Sales::InvoicesController < CrudController

  def pending_delivery_slips
    @delivery_slips = DeliverySlip.search(params[:search]).order(sort_column + " " + sort_direction).page(params[:page])
  end
  
  def invoice_delivery_slip
    ds = DeliverySlip.find(params[:id])
    @invoice = Invoice.new
    @invoice.build_from_delivery_slip(ds)  
  end

  def test
    invoice = resource
    template = "#{RAILS_ROOT}/data/invoice_template.pdf"
    tmp_filename = "#{RAILS_ROOT}/tmp/factura.pdf"
    Prawn::Document.new(:template => template,
                        :left_margin => 0,
                        :right_margin => 0,
                        :bottom_margin => 0,
                        :top_margin => 0 ) do
      self.font_size=9
      bounding_box [494, bounds.top - 40 ], :width => 78 do
        text invoice.date.strftime('%d/%m/%Y'), :size => 12, :align => :center
      end

      bounding_box [345, bounds.top - 22 ], :width => 120 do
        text "%04d" % invoice.pos + "-%08d" % invoice.doc_no, :size => 14
      end
      bounding_box [345, bounds.top - 43 ], :width => 120 do
        text "FACTURA", :size => 12
      end

      bounding_box [286, bounds.top - 22 ], :width => 26 do
        text "A", :size => 24, :align => :center
        text "cod 01", :size => 7, :align => :center
      end

      bounding_box [24, bounds.top - 130 ], :width => 549 do
        indent(60) do
          text invoice.customer.name
          a = invoice.customer.addresses.first
          text a.address
          text a.zipcode + " "*10 + a.location
        end
      end

      bounding_box [24, bounds.top - 180 ], :width => 549, :height=> 40 do
         table([['', '13330','','RESP. INSCRIPTO','',invoice.customer.str_cuit]]) do |t|
           t.cells.style :borders => [], :padding => 2
           t.column_widths = [80,140,40,130,50,100]
         end
      end

      bounding_box [24, bounds.top - 200 ], :width => 549, :height=> 40 do
         table([['', '30 dias FF con cheque de pago diferido','VTO.',invoice.due_date.strftime('%d/%m/%Y'),'','342345']]) do |t|
           t.cells.style :borders => [], :padding => 2
           t.column_widths = [80,220,30,60,50,100]
         end
      end


      items = []
      invoice.invoice_items.each do |ii|
        items << [ii.product.code, ii.qty.to_s,'',ii.description,"%.2f" % ii.unit_price,"%.2f" % ii.price]
      end
      bounding_box [24, bounds.top - 250 ], :width => 549, :height=> 350 do
         table(items) do |t|
           t.cells.style :borders => [], :padding => 2
           t.column_widths = [45,55,20,265,60,95]
           [0,1,4,5].each{|c|t.columns(c).align = :right}
         end
      end


      items = []
      items << ['',"%.2f" % invoice.taxed_amount]
      items << ['',"%.2f" % invoice.taxes_amount]
      items << ['',"%.2f" % invoice.taxed_amount]
      items << ['21%',"%.2f" % invoice.iva_amount]
      items << ['10.5%',"%.2f" % 0]
      items << ['Total',"%.2f" % invoice.total_amount]
      bounding_box [30, bounds.top - 600 ], :width => 400, :height=> 100 do
        font_size 9 do
          table( items) do |t|
            t.cells.style :borders => [], :padding => 1.2, :align => :right
            t.column_widths = [110, 80]
          end
        end
        move_down 9
        font_size 11 do
          table( [['', "%.2f" % invoice.total_amount]]) do |t|
            t.cells.style :borders => [], :padding => 4, :style => :bold, :align => :right
            t.column_widths = [110, 80]
          end
        end
        stroke_bounds
      end
  
      items = []
      items << ['',"%.2f" % invoice.taxed_amount]
      items << ['',"%.2f" % invoice.taxes_amount]
      items << ['',"%.2f" % invoice.taxed_amount]
      items << ['21%',"%.2f" % invoice.iva_amount]
      items << ['10.5%',"%.2f" % 0]
      bounding_box [375, bounds.top - 730 ], :width => 198, :height=> 96 do
        font_size 9 do
          table( items) do |t|
            t.cells.style :borders => [], :padding => 1.2, :align => :right
            t.column_widths = [110, 80]
          end
        end
        move_down 9
        font_size 11 do
          table( [['', "%.2f" % invoice.total_amount]]) do |t|
            t.cells.style :borders => [], :padding => 4, :style => :bold, :align => :right
            t.column_widths = [110, 80]
          end
        end
      end

      
      render_file tmp_filename
    end
  
    #send_file tmp_filename, :type => 'application/pdf', :disposition => 'attachment'
  
  end
  
  def get_cae
    #todo: validate afip_request
    #validate result
    
    response = AfipService::Wsfe.request_cae(resource.afip_request)
    result = response[:fecae_solicitar_response][:fecae_solicitar_result][:fe_det_resp][:fecae_det_response] rescue nil
    obs = result[:observaciones][:obs] rescue nil
    obs = [obs] unless obs.nil? || obs.kind_of?(Array)
    errors = response[:fecae_solicitar_response][:fecae_solicitar_result][:errors][:err] rescue nil
    errors = [errors] unless errors.nil? || errors.kind_of?(Array)
    flash_errors = []
    
    if result
      if result[:resultado]=="A"
        resource.cae = result[:cae]
        resource.cae_due_date = Date.parse(result[:cae_fch_vto])
        if resource.save
          flash[:notice] = "CAE obtenido: #{resource.cae}  -  fecha vto:#{resource.cae_due_date} para la factura #{resource.doc_no}."
        else
          flash_errors << "No se pudo guardar el CAE para la factura #{resource.doc_no}."
        end
      end
      flash_errors << "Las solicitud fue rechazada" if result[:resultado]=="R"
    else
      flash_errors << "Error inesperado. No se obtuvieron resultados de la AFIP para la factura #{resource.doc_no}."
    end

    errors.each{|e| flash_errors << "Error #{e[:code]}: #{e[:msg]}"} if errors
    obs.each{|o| flash_errors << "Observacion #{o[:code]}: #{o[:msg]}"} if obs

    flash[:error] = flash_errors.join('<br/>') unless flash_errors.empty?

    redirect_to collection_url
    
  end

  def build_access_invoice
    customer = Customer.find_by_code(params[:c])
    return render :text => "No se encuentra un cliente con codigo #{params[:c]}" unless customer
    @invoice = Invoice.new
    @invoice.date = Date.parse(params[:d])
    @invoice.doc_no = params[:f].to_i
    @invoice.currency_rate = params[:cr].to_f.round(3) unless @invoice.currency_id == 1
    @invoice.customer_id = customer.id
    @invoice.currency_id = 2 if params[:lc].to_i == 0
    @invoice.currency_rate = params[:cr].to_f.round(3) unless @invoice.currency_id == 1
    @invoice.memo = "Orden de Compra: #{params[:odc]}\n Remito: #{params[:r]}"
    total = 0
    params[:i].each do |i|
      product = Product.find_by_code(i[:p])
      return render :text => "No se encuentra un producto con codigo #{i[:p]}" unless product
      ii = @invoice.invoice_items.build({'product_id'=> product.id})
      ii.description = i[:d]
      ii.qty = i[:q].to_i
      ii.unit_price = i[:q].to_f.round(3)
      total += ii.price = (ii.qty * ii.unit_price).round(2)
    end
    @invoice.exempt_amount = 0
    @invoice.untaxed_amount = 0
    @invoice.taxes_amount = 0
    @invoice.taxed_amount = total
    @invoice.iva_amount = (total * 0.21).round(2)
    @invoice.total_amount = @invoice.taxed_amount + @invoice.iva_amount
  end
  
  def field_list
    ['doc_no','date','cae' ]
  end 
  
end




=begin

  headers = ["Date", "Patient Name", "Description", "Charges / Payments", 
             "Patient Portion Due", "Balance"]

  head = make_table([headers], :column_widths => [50, 90, 170, 90, 90, 50])

  data = []

  def row(date, pt, charges, portion_due, balance)
    rows = charges.map { |c| ["", "", c[0], c[1], "", ""] }

    # Date and Patient Name go on the first line.
    rows[0][0] = date
    rows[0][1] = pt

    # Due and Balance go on the last line.
    rows[-1][4] = portion_due
    rows[-1][5] = balance

    # Return a Prawn::Table object to be used as a subtable.
    make_table(rows) do |t|
      t.column_widths = [50, 90, 170, 90, 90, 50]
      t.cells.style :borders => [:left, :right], :padding => 2
      t.columns(4..5).align = :right
    end

  end

  data << row("1/1/2010", "", [["Balance Forward", ""]], "0.00", "0.00")
  50.times do
    data << row("1/1/2010", "John", [["Foo", "Bar"], 
                                     ["Foo", "Bar"]], "5.00", "0.00")
  end


  # Wrap head and each data element in an Array -- the outer table has only one
  # column.
  table([[head], *(data.map{|d| [d]})], :header => true,
        :row_colors => %w[cccccc ffffff]) do
    
    row(0).style :background_color => '000000', :text_color => 'ffffff'
    cells.style :borders => []
  end


    table([['codigo']*5]*4, :cell_style => { :padding => 12 }, :header => true,
        :row_colors => %w[e7e7e7 ffffff],:column_widths=>[45,75,265,75,85]) do
      #cells.borders = []
      # Use the row() and style() methods to select and style a row.
      #style row(0), :border_width => 2, :borders => [:bottom]

      # The style method can take a block, allowing you to customize properties
      # per-cell.
      #style(columns(0..1)) { |cell| cell.borders |= [:right] }
    end
    
=end
