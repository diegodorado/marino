class Comment
  include Mongoid::Document
  include Mongoid_Commentable::Comment
  include Mongoid::Timestamps
  belongs_to :author, :class_name => "User"
  attr_accessible :text, :author
  field :text, :type => String

  def as_json(options={})
    #options[:only] = [:id, :fecha, :tipo_doc, :debe, :haber, :precio_unitario]
    options[:methods] ||= []
    options[:methods] << :author_name
    super(options)
  end

  def author_name
    author.email rescue nil
  end



end
