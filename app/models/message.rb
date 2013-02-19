class Message
  include MongoMapper::Document
  #validates :creator, :presence => true


  key :fecha, Date
  key :tipo_doc, String
  key :debe, Integer
  key :haber, Integer
  key :precio_unitario , Integer


  userstamps!
  timestamps!


  def as_json(options={})
    #options[:only] = [:id, :fecha, :tipo_doc, :debe, :haber, :precio_unitario]
    #options[:methods] ||= []
    #options[:methods] << :tag_names
    super(options)    
    
  end

  def self.grid_column(column, editor=nil)
    gc = {
      :id => column,
      :name => column,
      :field => column,
      :cssClass => column,
      :headerCssClass => column,    
    }
    if editor
      gc[:editor] = editor 
    else
      gc[:selectable] = false
      gc[:focusable] = false
    end
    gc
  end

  def self.grid

    {
      :columns => [
        self.grid_column("fecha",'Slick.Editors.Date'),
        self.grid_column("tipo_doc",'Slick.Editors.Text'),
        self.grid_column("entrada",'Slick.Editors.Integer'),
        self.grid_column("salida",'Slick.Editors.Integer'),
        self.grid_column("saldo"),
        self.grid_column("precio_unitario",'Slick.Editors.Integer'),
        self.grid_column("debe"),
        self.grid_column("haber"),
        self.grid_column("saldo_p"),
      ],


      :options => {
        :enableCellNavigation => true,
        :enableColumnReorder => false,
        :editable => true,
        :enableAddRow => true,
        :autoEdit => true
      }
      
    }
  end


  

end
