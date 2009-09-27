module GUtopIa

  class Layout

    def initialize(&grid)
      @grid = grid.call
    end

    def apply(&grid)
      grid.call.each_with_index do |row, c|
        row.each_with_index do |cell, r|
          @grid[c,r].apply(cell)
        end
      end
    end

  end

end

