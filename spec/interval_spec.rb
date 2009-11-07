$:.unshift(File.dirname(__FILE__) + "/../lib")
require File.dirname(__FILE__) + '/spec_helper'
require "interval"
require "pp"

include Interval

describe "interval" do
  it "should reate from int" do
    v = Interval::Interval.from_int(1)
    pp v
    p v.to_long_name
  end
end