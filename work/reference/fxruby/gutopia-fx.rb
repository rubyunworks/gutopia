# GUtopIa - FOX Backend Platform
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

require 'fox'

include Fox

module GUtopIa

  class Platform < FXMainWindow
  
    def initialize(name, vendor)
      
      @gate = false
      
      @components = {}
      @store = {}
      
      @app = FXApp.new(name, vendor)
      @app.init(ARGV)
      
      super(@app, name, nil, nil, DECOR_ALL)
      
      #@false_parent = FXTopWindow.new(@app, 'false_parent', nil, nil, DECOR_ALL, 0, 0, 0, 0,
      #  DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_SPACING, DEFAULT_SPACING)
    
    end

    def start
      @app.create()
      @app.run #@app_thread = Thread.new { @app.run }
    end
    
    def stop
      
    end
    
    # signal router
    
    def signal(component, message, *args)
      case component
      when Window
        window(component, message, *args)
      when RadioBox
        radiobox(component, message, *args)
      when ListBox
        listbox(component, message, *args)
      when DropList
        droplist(component, message, *args)
      when Button
        button(component, message, *args)
      when Panel
        panel(component, message, *args)
      when Label
        label(component, message, *args)
      when TextField
        textfield(component, message, *args)
      when TextArea
        textarea(component, message, *args)
      when MenuBar
        menubar(component, message, *args)
      when Menu
        menu(component, message, *args)
      when MenuItem
        menuitem(component, message, *args)
      else
        puts 'NOT WORKING'
        puts component.type
      end
    end
    
    
    # component signals
    
    def window(component, message, *args)
      case message
      when :new
        @components[component] = FXTopWindow.new(@app, component.caption, nil, nil, DECOR_ALL, 0, 0, 0, 0, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_SPACING, DEFAULT_SPACING)
        #
        # menubar
        #
        if component.menu
          @components[component.menu].reparent(@components[component])
        end
        #
        # body layout
        #
        case component.layout
        when :grid
          amatrix = FXMatrix.new(@components[component], component.body.length, opts=MATRIX_BY_ROWS)
          # matrix inversion
          tbody = []
          component.body.length.times do |y|
            component.body[y].length.times do |x|
              tbody[x] = [] unless tbody[x]
              tbody[x][y] = component.body[y][x]
            end
          end
          tbody.each do |row|
            row.each do |col_component|
              @components[col_component].reparent(amatrix)
            end
          end
        end
      when :update
      
      when :show
        @components[component].show(PLACEMENT_SCREEN)
      when :hide
        @components[component].hide
      when :close
      
      end
    end
    
    
    def radiobox(component, message, *args)
      case message
      when :new
        @components[component] = FXGroupBox.new(self, '', LAYOUT_SIDE_TOP|FRAME_GROOVE|LAYOUT_FILL_X, 0, 0, 0, 0)
        @store[component] = {} 
        @store[component][:items] = []
        component.items.each_with_index do |item, i|
          @store[component][:items][i] = FXRadioButton.new(@components[component], item, nil, 0, JUSTIFY_LEFT|JUSTIFY_TOP|ICON_BEFORE_TEXT|LAYOUT_SIDE_TOP)
          @store[component][:items][i].setCheck(true) if @store[component][:items][i].to_s == component.value
          @store[component][:items][i].connect(SEL_COMMAND) { 
            if @store[component][:items][i].getCheck
              component.value = @store[component][:items][i].to_s
              component.change
            end
          }
        end
      when :update
      
      when :value=
        @store[component][:items].each do |fxrb|
          if fxrb.to_s == args[0]
            fxrb.setCheck(true)
          else
            fxrb.setCheck(false)
          end
        end
      end
    end
    
    
    def listbox(component, message, *args)
      case message
      when :new
        @components[component] = FXList.new(self, component.lines, nil, 0, LIST_BROWSESELECT|LAYOUT_FILL_X)
        component.items.each_with_index do |item, i|
          @components[component].appendItem(item)
        end
        @components[component].connect(SEL_COMMAND) {
          component.value = @components[component].getItemText(@components[component].getCurrentItem)
          component.change
        }
      when :update
      
      when :value=
        @components[component].each_with_index do |item, i|
          if item == args[0]
            @components[component].setCurrentItem(i)
          end
        end
      end
    end
    
    
    def droplist(component, message, *args)
      case message
      when :new
        @components[component] = FXComboBox.new(self, 1, component.lines, nil, 0, LAYOUT_FILL_X)
        @components[component].setEditable(false)
        component.items.each_with_index do |item, i|
          @components[component].appendItem(item)
        end
        @components[component].connect(SEL_COMMAND) {
          component.value = @components[component].getItemText(@components[component].getCurrentItem)
          component.change
        }
      when :update
      
      when :value=
        @components[component].each_with_index do |item, i|
          if item == args[0]
            @components[component].setCurrentItem(i)
          end
        end
      end
    end
    
    
    def button(component, message, *args)
      case message
      when :new
        @components[component] = FXButton.new(self, component.text, nil)
        @components[component].connect(SEL_COMMAND) {
          component.press
        }
      when :update
      
      end
    end


    def panel(component, message, *args)
      case message
      when :new
        case component.layout
        when :grid
          @components[component] = FXMatrix.new(self, component.body.length, opts=MATRIX_BY_ROWS)
          # matrix inversion
          tbody = []
          component.body.length.times do |y|
            component.body[y].length.times do |x|
              tbody[x] = [] unless tbody[x]
              tbody[x][y] = component.body[y][x]
            end
          end
          tbody.each do |row|
            row.each do |col_component|
              @components[col_component].reparent(@components[component])
            end
          end
        end
      when :update
      
      end
    end
    

    def label(component, message, *args)
      case message
      when :new
        @components[component] = FXLabel.new(self, component.text)
      when :update
      
      end
    end

    
    def textfield(component, message, *args)
      case message
      when :new
        @components[component] = FXTextField.new(self, component.columns, nil, 0, FRAME_NONE)
        @components[component].setText(component.value)
        @components[component].connect(SEL_UPDATE) { 
          @gate = true
          component.value = @components[component].getText
          component.change
          @gate = false
        }
      when :update
      
      when :value=
        @components[component].setText(args[0]) if not @gate
      end
    end


    def textarea(component, message, *args)
      case message
      when :new
        @components[component] = FXText.new(self)
        @components[component].setText(component.value)
        @components[component].setVisCols(component.columns)
        @components[component].setVisRows(component.lines)
        @components[component].connect(SEL_UPDATE) { 
          @gate = true
          component.value = @components[component].getText
          component.change
          @gate = false
        }
      when :update
      
      when :value=
        @components[component].setText(args[0]) if not @gate
      end
    end
    
    
    def menubar(component, message, *args)
      case message
      when :new
        @components[component] = FXMenubar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
        component.items.each do |item|
          @components[item].reparent(@components[component])
        end
      end
    end
    
    
    def menu(component, message, *args)
      case message
      when :new
        @store[component] = FXMenuPane.new(self)
        @components[component] = FXMenuTitle.new(self, component.text, nil, @store[component])
        component.items.each do |item|
          @components[item].reparent(@store[component])
        end
      end
    end
    
    
    def menuitem(component, message, *args)
      case message
      when :new
        @components[component] = FXMenuCommand.new(self, component.text)
        @components[component].connect(SEL_COMMAND) {
          component.press
        }
      end
    end

  end  # Platform

end  # GUtopIa
