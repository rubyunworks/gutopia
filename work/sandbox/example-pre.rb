# GUtopIa - More Sample Data Model
# Copyright (c) 2002 Thomas Sawyer

# GUtopIa is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# GUtopIa is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with GUtopIa; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

require 'gutopia'

module MyModels

  def MyModels.pick_model(which)
    case which
    when 'PC'
      return MyModels.pc_model #(gui)
    when 'PDA'
      return MyModels.pda_model #(gui)
    end
  end

  private

  # PC model using serial notatation (slower)
  def MyModels.pc_model #(gui)

    Proc.new {
  
      # RadioBox
      r = widgetFactory(:RadioBox, 'aradio')

      # Window
      w = widgetFactory(:Window, 'awindow')
      w.width = 640
      w.height = 400
      w.layout_manager = :grid
      w.layout = [ [ r ] ]
    
    }

  end

  # PDA model using parallel notation (faster)
  def MyModels.pda_model #(gui)

    Proc.new {
  
      # RadioBox
      r = widgetFactory(:RadioBox, 'aradio')

      # Window
      w = widgetFactory(:Window, 'awindow',
        :width  => 320,
        :height => 240,
        :layout_manager => :grid,
        :layout => [ [ r ] ]
      )
      
    }
    
  end

end  # MyModels
