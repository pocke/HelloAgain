require 'spec_helper'

describe Mongoid::Geospatial::Box do
  it 'should work' do
    alarm = Alarm.new(area: [[1, 2], [3, 4]])
    expect(alarm.area).to be_a Mongoid::Geospatial::Box
  end
end
