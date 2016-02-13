class Card
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :user
  field :user_id, type: Integer
end
