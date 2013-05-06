class Comment
  include Mongoid::Document
  include Mongoid_Commentable::Comment
  belongs_to :author, :class_name => "User"
  
  attr_accessible :text, :author
  field :text, :type => String

end
