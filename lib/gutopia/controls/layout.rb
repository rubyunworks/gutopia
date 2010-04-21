module GUtopIa

  #
  class Layout < Widget

    #
    def initialize(&grid)
      super()
      @grid = []
      build(&grid)
    end

    #
    def build(&grid)
      grid.call.each_with_index do |row, r|
        row.each_with_index do |cell, c|
          set(r,c){ cell }
        end
      end
    end

    #
    def set(row, col, &cell)
      @grid[row] ||= []
      case cell[]
      when Widget
        widget = cell
      when String
        widget = Label.new(cell)
      #when Numeric
        #widget = @grid[c][r].width = cell
      when Range
        #widget = 
      end
      if widget
        @grid[row][col] = widget
        @adapter.set(row, col, widget)
      end
    end

    #
    #def apply(&grid)
    #  grid.call.each_with_index do |row, r|
    #    row.each_with_index do |cell, c|
    #      @grid[r][c].apply(cell)
    #    end
    #  end
    #end

    #
    def show
      @adapter.show
    end

    #
    def method_missing(sym, grid)
      grid.each_with_index do |row, r|
        row.each_with_index do |col, c|
          cell = @grid[r][c]
          cell.__send__(sym, col) if cell.respond_to(sym)
        end
      end
    end

  end

end

