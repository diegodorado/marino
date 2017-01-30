class Company
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  belongs_to :owner, :class_name => "User", :inverse_of => :own_companies
  belongs_to :auditor, :class_name => "User", :inverse_of => :audited_companies
  has_and_belongs_to_many :auditors, :class_name => "User", :inverse_of => :audited_companies
  has_and_belongs_to_many :users, :class_name => "User", :inverse_of => :companies
  has_many :stores, :inverse_of => :company

  field :name
  slug :name

  def as_json(options={})
    options[:only] ||= [:_id, :slug, :name]
    super(options)
  end

end
