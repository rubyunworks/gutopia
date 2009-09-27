module GUtopIa

  class DropDown

    # options to select from
    attr :options

    # selected value(s)
    attr :value

    def initialize(*options)
      @options = options
      @value   = []
    end

    def value=(v)
      if options.include?(v)
        @value |= [v]
      else
        raise ArgumentError
      end
    end

    def <<(v)
      if options.include?(v)
        @value |= [v]
      else
        raise ArgumentError
      end
    end

  end

end

