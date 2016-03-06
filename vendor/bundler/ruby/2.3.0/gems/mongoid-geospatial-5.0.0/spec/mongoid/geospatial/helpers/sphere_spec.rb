require 'spec_helper'

describe Mongoid::Fields do
  context 'spatial' do
    before do
      Alarm.create_indexes
    end

    it 'should created indexes' do
      expect(Alarm.collection.indexes.get(spot: '2dsphere')).not_to be_nil
    end

    it 'should create correct indexes' do
      expect(Alarm.collection.indexes.get(spot: '2dsphere'))
        .to eq('2dsphereIndexVersion' => 2,
               'key' => { 'spot' => '2dsphere' },
               'name' => 'spot_2dsphere',
               'ns' => 'mongoid_geo_test.alarms',
               'v' => 1)
    end

    it 'should set spatial fields' do
      expect(Alarm.spatial_fields).to eql([:spot])
    end

    it 'should work fine indexed' do
      far  = Alarm.create!(name: 'Far', spot: [7, 7])
      expect(far.spot).to be_instance_of(Mongoid::Geospatial::Point)
    end
  end
end
