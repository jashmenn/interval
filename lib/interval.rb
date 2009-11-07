module Interval
  class Pitch
    attr_accessor :octave
    attr_accessor :notename
    attr_accessor :accidental
  end

  class Interval
    attr_accessor :direction # value to be 1 or -1
    attr_accessor :octave # 0, 1, 2, 3 etc
    attr_accessor :interval # 1:unison, 2:second, ... 7: seventh
        # unison:              dim   perfect   aug
        # second:  -2:dim -1:minor 0:major   1:aug
        # third:      dim    minor   major     aug
        # fourth:              dim   perfect   aug
        # fifth:               dim   perfect   aug
        # sixth:      dim    minor   major     aug
        # seventh:    dim    minor   major     aug
    attr_accessor :mod # -2:dim -1:minor 0:major   1:aug

    QUALITY_LONG_NAMES = {
      'p' => 'Perfect',
      'dd' => 'Doubly-diminished',
      'd' => 'Diminished',
      'm' => 'Minor',
      'M' => 'Major',
      'a' => 'Augmented',
      'aa' => 'Doubly-augmented',
    }

    SIZE_LONG_NAMES = %w{x 
      Unison
      Second
      Third
      Fourth
      Fifth
      Sixth
      Seventh
      Octave
    }

    class << self

# Number of
# semitones	name	enharmonic notes
# 0	Perfect Unison (P1)	Diminished second (dim2)
# 1	Minor second (m2)	Augmented unison (aug1)
# 2	Major second (M2)	Diminished third (dim3)
# 3	Minor third (m3)	Augmented second (aug2)
# 4	Major third (M3)	Diminished fourth (dim4)
# 5	Perfect fourth (P4)	Augmented third (aug3)
# 6	Tritone	Augmented fourth (aug4)
# Diminished fifth (dim5)
# 7	Perfect fifth (P5)	Diminished sixth (dim6)
# 8	Minor sixth (m6)	Augmented fifth (aug5)
# 9	Major sixth (M6)	Diminished seventh (dim7)
# 10	Minor seventh (m7)	Augmented sixth (aug6)
# 11	Major seventh (M7)	Diminished octave (dim8)
# 12	Perfect octave (P8)	Augmented seventh (aug7)

      # unison  p1
      # second  m2 M2
      # third   m3 M3
      # fourth  p4
      # fifth   d5 5
      # sixth   m6 M6
      # seventh m7 M7
      # octave  p8
      def from_string str
      end

      def from_int(number)
        interval = new
        interval.direction = number >= 0 ? 1 : -1
        interval.octave = number.abs / 12
        mod, intervali = *([
               [0, 1],          # unison
               [-1, 2], [0, 2], # second
               [-1, 3], [0, 3], # third
               [0, 4],          # fourth
               [-1, 5],         # dim 5, tritone
               [0, 5],          # fifth
               [-1, 6], [0, 6], # sixth
               [-1, 7], [0, 7]])[number.abs % 12] # seventh
        interval.mod = mod 
        interval.interval = intervali
        interval
      end


    end

    def to_long_name
      short_modifier = case self.interval 
      when 2, 3, 6, 7  
        {-2 => "d", -1 => "m", 0 => "M", 1 => "a"}[self.mod]
      when 1, 4, 5, 8  
        {-1 => "d",  0 => "p", 1 => "a"}[self.mod]
      else
        raise "unknown interval"
      end

      long_modifier = QUALITY_LONG_NAMES[short_modifier]
      size = SIZE_LONG_NAMES[self.interval]
      size = "Octave" if interval == 1 && octave > 0 
      return "%s %s" % [long_modifier, size]
    end
  end
end
