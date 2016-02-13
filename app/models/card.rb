class Card
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String, default: ""
  belongs_to :user
end
