class Crop
  include Mongoid::Document

  field :name
  field :market
  field :source
  field :unit
  field :prices, :type => Hash



  def as_json(options={})
    #options[:include] = [:crop_prices]

    attrs = super(options)
    #attrs["id"] = self.persisted? ? self._id : nil
    #attrs.merge! attrs.delete 'prices'
    attrs
  end

  def update_price(month, price, user)
    self.prices ||= {}
    self.prices.merge! Hash[month,price]
    self.save
  end

  def get_price(month)
    self.prices ||= {}
    self.prices[month]
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



end
