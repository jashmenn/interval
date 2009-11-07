module Interval
  class Pitch
    NOTE_NAMES = %w{c d e f g a b}
    NOTE_NAMES_TO_I = {'c' => 0, 'd' => 1, 'e' => 2, 'f' => 3, 'g' => 4, 'a' => 5, 'b' => 6}

    attr_accessor :octave
    attr_accessor :notename_i
    attr_accessor :accidental

    class << self
      def from_string(str)
        p = new
        ary = str.split(//) 
        possible_notename = ary.shift.downcase
        raise "invalid notename: #{possible_notename}" unless Pitch::NOTE_NAMES_TO_I.has_key?(possible_notename)
        p.notename_i = note_s_to_i(possible_notename)

        octave = 0
        accidental = 0
        while(char = ary.shift)
          octave = octave + 1 if char == "'"
          octave = octave - 1 if char == ","
          accidental = accidental + 1 if char == "#"
          accidental = accidental - 1 if char == "b"
        end
        p.octave = octave
        p.accidental = accidental
        p
      end

      def from_int(midiint)
        p = new
        p.octave = (midiint - 48) / 12
        p.notename_i = {0 => 0, 1 => 0, 
                      2 => 1, 3 => 1, 
                      4 => 2, 
                      5 => 3, 6 => 3, 
                      7 => 4, 8 => 4,
                      9 => 5, 10 => 5, 
                      11 => 6}[midiint % 12]
        p.accidental = midiint - (p.octave + 4) * 12 - ([0, 2, 4, 5, 7, 9, 11][p.notename_i])
        p
      end

      def notename_s(s)
        NOTE_NAMES[s]
      end

      # def notename_s(s)
      #   {0 => 'c', 1 => 'c', 
      #    2 => 'd', 3 => 'd', 
      #    4 => 'e', 
      #    5 => 'f', 6 => 'f', 
      #    7 => 'g', 8 => 'g', 
      #    9 => 'a', 10 => 'a', 
      #    11 => 'c'}[s]
      # end

      # i dont think this is right. also, just start storing notename as an integer. make it a lot easier
      # this isn't notename_i!!! this is some strange mididint accidental array. todo, redo this
      # def pitchy(i)
      #   notes = 
      #   {'c' => 0,
      #    'd' => 2,
      #    'e' => 4,
      #    'f' => 5,
      #    'g' => 6,
      #    'a' => 9,
      #    'b' => 11}
      #   notes[i]
      # end

      # def note_i_to_s(i)
        # NOTENAMES[i]
      # end

      def note_s_to_i(s)
        NOTE_NAMES_TO_I[s]
      end

      def accidental_name(i)
        names =
        { -2 => " double flat",
          -1 => " flat",
          0 => "",
          1 => " sharp",
          2 => " double sharp" }
        names[i]
      end
    end

    def semitone_pitch
      [0, 2, 4, 5, 7, 9, 11][notename_i] + accidental + (octave * 12) + 48
    end

    # def notename_i
      # self.class.notename_i(self.notename)
    # end

    # def notename_i=(i)
    # end

    def notename
      self.class.notename_s(notename_i)
    end

    def to_long_name
      "%s%s" % [notename.upcase, self.class.accidental_name(accidental)]
    end

    def to_short_name
      "%s%s" % [notename, accidental > 0 ? ('#' * accidental.abs) : ('b' * accidental.abs)]
    end

    def +(other)
      if other.kind_of?(Interval)
        plus_interval(other)
      else
        raise "todo"
      end
    end

    private
    def plus_interval(other)
      r = self.dup
      _p = r.semitone_pitch
      r.notename_i = r.notename_i + (other.interval - 1) * other.direction
      r.octave = r.octave + r.notename_i / 7 + other.octave * other.direction
      r.notename_i = r.notename_i % 7
      _diff = r.semitone_pitch - _p
      r.accidental = r.accidental + (other.to_i - _diff)
      r
    end
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
      # 6	Tritone	Augmented fourth (aug4) Diminished fifth (dim5)
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
      def from_string(str)
        i = new
        i.direction = str[0] == "-" ? -1 : 1
        str =~ /([mMdap])(\d+)/
        modifier, size = $1,$2
        raise "#{str} is not a valid interval" unless modifier && size
        size = size.to_i
        if size <= 7 
          i.octave = 0
        else
          i.octave = size % 8 # ?
        end
        i.interval = size - (i.octave * 7)

        i.mod = case i.interval 
        when 2, 3, 6, 7  
          {"d" => -2, "m" => -1, "M" => 0, "a" => 1}[modifier]
        when 1, 4, 5, 8  
          {"d" => -1, "p" => 0, "a" => 1}[modifier]
        else
          raise "unknown interval"
        end

        i
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

      # tritone (diminished fifth) has the following: todo
      #<Interval::Interval:0x2efa90 @mod=0, @interval=5, @octave=0, @direction=1>

      return "%s %s" % [long_modifier, size]

    end

    def to_i
      return ([0, 0, 2, 4, 5, 7, 9, 11][interval] + octave * 12 + mod) * direction
    end
 
  end
end
