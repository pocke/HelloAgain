class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :name,  type: String, default: ""
  field :user_ids, type: Array, default: []

  def self.date(day)
    return self.where(created_at: day.beginning_of_day..day.end_of_day).first
  end
end
