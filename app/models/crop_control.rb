class CropControl
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :updater, class_name: "User"
  belongs_to :store
  belongs_to :crop

  field :fecha #, type: Date
  field :tipo_doc
  field :entrada, type: Float
  field :salida, type: Float
  field :precio_unitario, type: Float
  field :comentario
  field :gestion, type: Boolean
  field :contabilidad, type: Boolean


  def as_json(options={})
    options[:methods] ||= []
    options[:methods] << :updater_email
    attrs = super(options)
    attrs
  end

  def updater_email
    updater.email rescue nil
  end

  def crop_name
    crop.name rescue nil
  end

  def self.summary(balance_at, store_ids)


    map = %Q{
      function() {

        var values = {
          fecha: this.fecha,
          tn_gest: this.gestion ?  (this.entrada-this.salida) : 0,
          unit_gest: this.gestion ? this.precio_unitario : 0,
          tn_cont: this.contabilidad ?  (this.entrada-this.salida) : 0,
          unit_cont: this.contabilidad ? this.precio_unitario : 0
          };

          emit( this.crop_id, values);
        }
      }

    reduce = %Q{
      function(key, values) {

        var result =  {tn_gest: 0, unit_gest:0,  tn_cont: 0, unit_cont:0 };
        var date_gest = "";
        var date_cont = "";
        values.forEach( function(value) {
          result.tn_gest += value.tn_gest;
          result.tn_cont += value.tn_cont;
          if(value.fecha>date_gest && value.unit_gest>0){
            date_gest = value.fecha;
            result.unit_gest = value.unit_gest;
          }
          if(value.fecha>date_cont && value.unit_cont>0){
            date_cont = value.fecha;
            result.unit_cont = value.unit_cont;
          }
          });

        return result;
      }
    }

    result = self.in(store_id: store_ids)
      .where(:fecha.lte => balance_at)
      .map_reduce(map, reduce)
      .out(inline: 1)
      .map do |x|
        x["value"]["cropname"] = Crop.find(x["_id"]).name
        x["value"]
      end

    result

  end


  def self.list(store_id, crop_id, gestion)

      filter = {:store_id=>store_id,:crop_id=>crop_id}
      if gestion
        filter[:gestion] = true
      else
        filter[:contabilidad] = true
      end


      result = self
        .where(filter)
        .order_by(:fecha => :asc, :created_at => :asc)

      precio_anterior = 0
      saldo = 0
      saldo_p = 0
      result = result.map do |doc|
        doc[:entrada] ||= 0
        doc[:salida] ||= 0
        #utilizar el precio anterior si no lleva ninguno o si es cero
        doc[:precio_unitario] = precio_anterior if doc[:precio_unitario].to_f.zero?
        
        doc[:fecha].slice!(10..-1) #removes iso8601 extra chars from fecha



        saldo += doc[:entrada]-doc[:salida];
        doc[:saldo] = saldo.round(3)


        if doc[:tipo_doc] == 'VALUACION'
          cant =  (doc[:precio_unitario]  - precio_anterior) * saldo
          if cant >= 0
            doc[:debe] = cant
            doc[:haber] = 0
          else
            doc[:debe] = 0
            doc[:haber] = -cant
          end
        else
          doc[:debe] = doc[:entrada]*doc[:precio_unitario]
          doc[:haber] = doc[:salida]*doc[:precio_unitario]

        end

        saldo_p += doc[:debe]-doc[:haber]
        doc[:saldo_p] = saldo_p
        #watch out! first item cant be valuacion
        precio_anterior = doc[:precio_unitario]

        doc
      end

      result

  end


end
