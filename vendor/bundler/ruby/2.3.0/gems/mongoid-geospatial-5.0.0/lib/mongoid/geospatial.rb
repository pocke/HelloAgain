require 'mongoid'
# require 'active_support/core_ext/string/inflections'
# require 'active_support/concern'
require 'mongoid/geospatial/helpers/spatial'
require 'mongoid/geospatial/helpers/sphere'
require 'mongoid/geospatial/helpers/delegate'

module Mongoid
  #
  # Main Geospatial module
  #
  # include Mongoid::Geospatial
  #
  module Geospatial
    autoload :GeometryField, 'mongoid/geospatial/geometry_field'

    autoload :Point,         'mongoid/geospatial/fields/point'
    autoload :LineString,    'mongoid/geospatial/fields/line_string'
    autoload :Polygon,       'mongoid/geospatial/fields/polygon'

    autoload :Box,           'mongoid/geospatial/fields/box'
    autoload :Circle,        'mongoid/geospatial/fields/circle'

    autoload :VERSION,       'mongoid/geospatial/version'

    extend ActiveSupport::Concern

    # Symbols accepted as 'longitude', 'x'...
    LNG_SYMBOLS = [:x, :lon, :long, :lng, :longitude,
                   'x', 'lon', 'long', 'lng', 'longitude']

    # Symbols accepted as 'latitude', 'y'...
    LAT_SYMBOLS = [:y, :lat, :latitude, 'y', 'lat', 'latitude']

    # For distance spherical calculations
    EARTH_RADIUS_KM = 6371 # taken directly from mongodb
    RAD_PER_DEG = Math::PI / 180

    # Earth radius in multiple units
    EARTH_RADIUS = {
      m:  EARTH_RADIUS_KM * 1000,
      km: EARTH_RADIUS_KM,
      mi: EARTH_RADIUS_KM * 0.621371192,
      ft: EARTH_RADIUS_KM * 5280 * 0.621371192,
      sm: EARTH_RADIUS_KM * 0.53995680345572 # sea mile
    }

    mattr_accessor :lng_symbols
    mattr_accessor :lat_symbols
    mattr_accessor :earth_radius
    mattr_accessor :factory

    @@lng_symbols  = LNG_SYMBOLS.dup
    @@lat_symbols  = LAT_SYMBOLS.dup
    @@earth_radius = EARTH_RADIUS.dup

    included do
      # attr_accessor :geo
      cattr_accessor :spatial_fields, :spatial_fields_indexed
      self.spatial_fields = []
      self.spatial_fields_indexed = []
    end

    def self.with_rgeo!
      require 'mongoid/geospatial/wrappers/rgeo'
    end

    def self.with_georuby!
      require 'mongoid/geospatial/wrappers/georuby'
    end

    # Methods applied to Document's class
    module ClassMethods
      #
      # Create Spatial index for given field
      #
      #
      # @param [String,Symbol] name
      # @param [Hash] options options for spatial_index
      #
      # http://www.mongodb.org/display/DOCS/Geospatial+Indexing
      # #GeospatialIndexing-geoNearCommand
      #
      def spatial_index(name, options = {})
        spatial_fields_indexed << name
        index({ name => '2d' }, options)
      end

      #
      # Creates Sphere index for given field
      #
      #
      # @param [String,Symbol] name
      # @param [Hash] options options for spatial_index
      #
      # http://www.mongodb.org/display/DOCS/Geospatial+Indexing
      # #GeospatialIndexing-geoNearCommand
      def sphere_index(name, options = {})
        spatial_fields_indexed << name
        index({ name => '2dsphere' }, options)
      end

      #
      # Creates Sphere index for given field
      #
      #
      # @param [String,Symbol] name
      # @param [Hash] options options for spatial_index
      #
      # http://www.mongodb.org/display/DOCS/Geospatial+Indexing
      # #GeospatialIndexing-geoNearCommand
      def spatial_scope(field, _opts = {})
        singleton_class.class_eval do
          # define_method(:close) do |args|
          define_method(:nearby) do |args|
            queryable.where(field.near_sphere => args)
          end
        end
      end
    end
  end
end
