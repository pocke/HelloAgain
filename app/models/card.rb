class Card
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :name, type: String, default: ""
  field :affiliation, type: String, default: ""
  field :phone, type: String, default: ""
  field :position, type: String, default: ""
  belongs_to :user

  def met?(current_event, current_user)
    evs = Event.all
    evs.reject!{|e| e.id == current_event.id }
      .select!{|e| e.user_ids.include? current_user.id }
      .select!{|x| e.user_ids.include? self.user.id }
    evs.first
  end
end
