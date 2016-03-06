require 'spec_helper'

describe Mongoid::Geospatial::Circle do
  it 'should work' do
    alarm = Alarm.new(radius: [[1, 2], 3])
    expect(alarm.radius).to be_a Mongoid::Geospatial::Circle
  end
end
