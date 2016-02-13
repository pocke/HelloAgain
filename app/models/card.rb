class Card
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String, default: ""
  field :affiliation, type: String, default: ""
  field :phone, type: String, default: ""
  field :position, type: String, default: ""
  belongs_to :user
end
