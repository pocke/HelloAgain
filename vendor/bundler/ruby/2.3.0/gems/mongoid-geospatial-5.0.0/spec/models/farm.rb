# Sample spec class
class Farm
  include Mongoid::Document
  include Mongoid::Geospatial

  field :name,         type: String
  field :geom,         type: Point,    sphere: true
  field :area,         type: Polygon,  spatial: true
  field :m2,           type: Fixnum

  spatial_index :geom
  spatial_index :area
end
