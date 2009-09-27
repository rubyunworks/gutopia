module GUtopIa

  class DropDown

    # options to select from
    attr :options

    # selected value
    attr :value

    def initialize(*options)
      @options = options
      @value   = nil
    end

    def value=(v)
      if options.include?(v)
        @value = v
      else
        raise ArgumentError
      end
    end

  end

end

