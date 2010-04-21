module GUtopIa

  #
  class Label < Widget

    def initialize(text)
      super(text)
    end

    def text
      @adapter.text
    end

    def text=(string)
      @adapter.text = string
    end

  end

end

