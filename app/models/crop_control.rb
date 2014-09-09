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

end
