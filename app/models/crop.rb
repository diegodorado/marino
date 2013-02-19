class Crop
  include MongoMapper::Document

  key :name, String
  key :market, String
  key :source, String
  key :unit, String

  many :crop_prices



  def as_json(options={})
    options[:include] = [:crop_prices]
    results = super(options)
    crop_prices = results['crop_prices']
    results.delete 'crop_prices'
    crop_prices.each { |cp| results[cp['month']] = cp['price'] }
    results
  end

  def update_price(month, price, user)

    cp = crop_prices.find_or_create_by_month(month)
    cp.price = price
    cp.creator_id ||= user.id
    cp.updater_id = user.id
    cp.save
    
  end

  def self.grid_column(column)
    {
      :id => column,
      :name => column,
      :field => column
    }
  end

  def self.price_columns
  
    result = []
    d = 30.months.ago.at_beginning_of_month
    
    while d < Date.today
      result << {:id => "#{d.strftime("%Y-%m-%d")}",:name => "#{d.strftime("%b %Y")}",:field => "#{d.strftime("%Y-%m-%d")}", :editor => 'Slick.Editors.Integer' }
      d = d.next_month
    end
    result
  end

  def self.grid

    {
      :columns => [
        self.grid_column("name"),
        self.grid_column("market"),
        self.grid_column("source"),
        self.grid_column("unit")
      ]+price_columns,


      :options => {
        :enableCellNavigation => true,
        :editable => true,
        :asyncEditorLoading => false,
        :autoEdit => true
      }, 
      
      :data => self.all
      
    }
  end


end
