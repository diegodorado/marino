class CropControl
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :updater, class_name: "User"
  belongs_to :store
  belongs_to :crop

  field :fecha #, type: Date
  field :tipo_doc
  field :entrada
  field :salida
  field :precio_unitario
  field :comentario


  def as_json(options={})

    #options[:only] = [:id, :fecha, :tipo_doc, :debe, :haber, :precio_unitario]
    options[:methods] ||= []
    options[:methods] << :updater_email
    attrs = super(options)
    #attrs["id"] = attrs["_id"]
    attrs
  end

  def updater_email
    updater.email rescue nil
  end

  def crop_name
    crop.name rescue nil
  end

end


