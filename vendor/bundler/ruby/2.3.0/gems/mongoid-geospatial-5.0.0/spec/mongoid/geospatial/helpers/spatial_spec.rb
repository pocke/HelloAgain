require 'spec_helper'

describe Mongoid::Fields do
  context 'spatial' do
    before do
      Bar.create_indexes
    end

    it 'should created indexes' do
      expect(Bar.collection.indexes.get(location: '2d')).not_to be_nil
    end

    it 'should create correct indexes' do
      expect(Bar.collection.indexes.get(location: '2d'))
        .to eq('key' => { 'location' => '2d' },
               'name' => 'location_2d',
               'ns' => 'mongoid_geo_test.bars',
               'v' => 1)
    end

    it 'should set spatial fields' do
      expect(Bar.spatial_fields).to eql([:location])
    end

    it 'should set some class methods' do
      far  = Bar.create!(name: 'Far', location: [7, 7])
      near = Bar.create!(name: 'Near', location: [2, 2])
      expect(Bar.nearby([1, 1])).to eq([near, far])
    end

    # it "should set some class methods" do
    #   far  = Bar.create!(name: "Far", location: [7,7])
    #   near = Bar.create!(name: "Near", location: [2,2])
    #   Bar.near_location([1,1]).should eq([near, far])
    # end
  end

  context 'geom' do
  end
end
