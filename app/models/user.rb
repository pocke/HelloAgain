class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  has_secure_password
end
