$:.unshift(File.dirname(__FILE__) + "/../lib")
require File.dirname(__FILE__) + '/spec_helper'
require "interval"
require "pp"

include Interval

describe "interval" do
  it "should create from int" do
    test_set = {
      0 => "Perfect Unison",
      1 => "Minor second",
      2 => "Major second",
      3 => "Minor third",
      4 => "Major third",
      5 => "Perfect fourth",
      6 => "Diminished fifth",
      7 => "Perfect fifth",
      8 => "Minor sixth",
      9 => "Major sixth",
      10 => "Minor seventh",
      11 => "Major seventh",
      12 => "Perfect octave"}

    test_set.keys.sort.each do |k|
      value = test_set[k]
      v = Interval::Interval.from_int(k)
      v.to_long_name.downcase.should == value.downcase
    end

  end
end