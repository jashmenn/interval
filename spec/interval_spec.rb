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
      v.to_i.should == k
    end
  end

  it "should create from string" do
    test_set = [
      ["p1", "Perfect Unison"],
      ["m2", "Minor second"],
      ["M2", "Major second"],
      ["m3", "Minor third"],
      ["M3", "Major third"],
      ["p4", "Perfect fourth"],
      ["d5", "Diminished fifth"],
      ["p5", "Perfect fifth"],
      ["m6", "Minor sixth"],
      ["M6", "Major sixth"],
      ["m7", "Minor seventh"],
      ["M7", "Major seventh"],
      ["p8", "Perfect octave"]]
    test_set.each do |key,value|
      v = Interval::Interval.from_string(key)
      v.to_long_name.downcase.should == value.downcase
    end
  end
end

describe "pitch" do
  it "should create from string and integer" do

    p = Interval::Pitch.from_string("c")
    p.notename_i.should == 0
    p.notename.should == "c"
    p.accidental.should == 0
    p.octave.should == 0

    p2 = Interval::Pitch.from_int(p.semitone_pitch)
    p2.notename.should == "c"
    p2.accidental.should == 0
    p2.octave.should == 0

    p2.to_long_name.should == "C"
    p2.to_short_name.should == "c"

    p.semitone_pitch.should == p2.semitone_pitch

    p = Interval::Pitch.from_string("c#'")
    p.notename.should == "c"
    p.accidental.should == 1
    p.octave.should == 1

    p2 = Interval::Pitch.from_int(p.semitone_pitch)
    p2.notename.should == "c"
    p2.accidental.should == 1
    p2.octave.should == 1

    p2.to_long_name.should == "C sharp"
    p2.to_short_name.should == "c#"

    p.semitone_pitch.should == p2.semitone_pitch
 
    p = Interval::Pitch.from_string("eb,,")
    p.notename.should == "e"
    p.accidental.should == -1 
    p.octave.should == -2 

    p2 = Interval::Pitch.from_int(p.semitone_pitch)
    
    p2.notename.should == "d"
    p2.accidental.should == 1 
    p2.octave.should == -2 

    p2.to_long_name.should == "D sharp"
    p2.to_short_name.should == "d#"

    p.semitone_pitch.should == p2.semitone_pitch
  end

  describe "adding intervals" do

  it "should be able to be added to an interval" do
    p = Pitch.from_string("c")
    i = Interval::Interval.from_string("M3")
    p2 = p + i
    p2.to_short_name.should == "e"
  end

  it "should add minor seconds" do
    i = Interval::Interval.from_string("m2")
    [["c", "db"],
     ["f", "gb"],
     ["Bb", "cb"],
     ["eb", "fb"],
     ["ab", "bbb"],
     ["db", "ebb"],
     ["gb", "abb"],
     ["f#", "g"],
     ["b", "c"],
     ["e", "f"],
     ["a", "bb"],
     ["d", "eb"],
     ["g", "ab"]
    ].each do |pitch, new_pitch|
       (Pitch.from_string(pitch) + i).to_short_name.should == new_pitch
     end
  end

  it "should add major seconds" do
    i = Interval::Interval.from_string("M2")
    [["c", "d"],
     ["f", "g"],
     ["Bb", "c"],
     ["eb", "f"],
     ["ab", "bb"],
     ["db", "eb"],
     ["gb", "ab"],
     ["f#", "g#"],
     ["b", "c#"],
     ["e", "f#"],
     ["a", "b"],
     ["d", "e"],
     ["g", "a"]
    ].each do |pitch, new_pitch|
       (Pitch.from_string(pitch) + i).to_short_name.should == new_pitch
     end
  end

  it "should add minor thirds" do
    i = Interval::Interval.from_string("m3")
    [["c", "d"],
     ["f", "g"],
     ["Bb", "c"],
     ["eb", "f"],
     ["ab", "bb"],
     ["db", "eb"],
     ["gb", "ab"],
     ["f#", "g#"],
     ["b", "c#"],
     ["e", "f#"],
     ["a", "b"],
     ["d", "e"],
     ["g", "a"]
    ].each do |pitch, new_pitch|
       (Pitch.from_string(pitch) + i).to_short_name.should == new_pitch
     end
  end

  it "should add major thirds" do
    i = Interval::Interval.from_string("M3")
    [["c", "e"],
     ["f", "a"],
     ["Bb", "d"],
     ["eb", "g"],
     ["ab", "c"],
     ["db", "f"],
     ["gb", "bb"],
     ["f#", "a#"],
     ["b", "d#"],
     ["e", "g#"],
     ["a", "c#"],
     ["d", "f#"],
     ["g", "b"]
    ].each do |pitch, new_pitch|
       (Pitch.from_string(pitch) + i).to_short_name.should == new_pitch
     end

  end

  it "should add perfect fifths" do
    i = Interval::Interval.from_string("p5")
    [["c", "g"],
     ["f", "c"],
     ["Bb", "f"],
     ["eb", "bb"],
     ["ab", "eb"],
     ["db", "ab"],
     ["gb", "db"],
     ["f#", "c#"],
     ["b", "f#"],
     ["e", "b"],
     ["a", "e"],
     ["d", "a"],
     ["g", "d"]
    ].each do |pitch, new_pitch|
       (Pitch.from_string(pitch) + i).to_short_name.should == new_pitch
     end
  end

  end
end