class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :name,  type: String, default: ""
  field :user_ids, type: Array, default: []
end
