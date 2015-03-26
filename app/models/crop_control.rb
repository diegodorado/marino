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

        values.forEach( function(value) {
          result.tn_gest += value.tn_gest;
          result.unit_gest = value.unit_gest;
          result.tn_cont += value.tn_cont;
          result.unit_cont = value.unit_cont;
          });

          return result;
        }
      }

    @result = self.in(store_id: store_ids)
      .where(:fecha.lte => balance_at)
      .order_by(:fecha => :asc)
      .map_reduce(map, reduce)
      .out(inline: 1)
      .map do |x|
        x["value"]["cropname"] = Crop.find(x["_id"]).name
        x["value"]
      end

    @result

  end

end
