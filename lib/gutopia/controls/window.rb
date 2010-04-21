module GUtopIa

  #
  class Window < Widget

    #
    def initialize(&grid)
      super
      @layout = Layout.new(&grid)
    end

    def show
      @layout.show
    end
 
  end

end

