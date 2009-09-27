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

require 'wise/wise'

module GUtopIa

  class Platform
  
    def initialize
      
      @gate = false
      
      @components = {}
      @store = {}
      
      #@app = FXApp.new(name, vendor)
      #@app.init(ARGV)
      
      #super(@app, name, nil, nil, DECOR_ALL)
      
      #@false_parent = FXTopWindow.new(@app, 'false_parent', nil, nil, DECOR_ALL, 0, 0, 0, 0,
      #  DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_SPACING, DEFAULT_SPACING)
    
    end

    def start
      Gtk::main
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
        @components[component] = Wise::Window.new(nil)
        #@components[component].set_title(component.caption)
        #
        # body layout
        #
        avbox = Gtk::VBox.new
        #
        # menubar
        #
        if component.menu
          avbox.add(@components[component.menu])
        end
        #
        case component.layout
        when :grid
          amatrix = Gtk::Table.new(component.body.length, component.body[0].length)
          component.body.each_with_index do |row, i|
            row.each_with_index do |col_component, j|
              amatrix.attach(@components[col_component], j, j+1, i, i+1)
            end
          end
          avbox.add(amatrix)
          amatrix.show
          @components[component].add(avbox)
          avbox.show
        end
      when :update
      
      when :show
        @components[component].show
      when :hide
        @components[component].hide
      when :close
      
      end
    end
    
    
    def radiobox(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::VBox.new
        @store[component] = {} 
        @store[component][:items] = []
        component.items.each_with_index do |item, i|
          @store[component][:items][i] = Gtk::RadioButton.new(i==0 ? nil : @store[component][:items][i-1], item)
          #@store[component][:items][i].setCheck(true) if @store[component][:items][i].to_s == component.value
          @store[component][:items][i].signal_connect(Gtk::RadioButton::SIGNAL_CLICKED) { 
            if @store[component][:items][i].active?
              @gate = true
              component.value = @store[component][:items][i].to_s
              component.change
              @gate = false
            end
          }
          @components[component].add(@store[component][:items][i])
          @store[component][:items][i].show
        end
        @components[component].show
      when :update
      
      when :value=
        if not @gate
          @store[component][:items].each do |rb|
            if rb.get_name == args[0]
              rb.set_state(true)
            else
              rb.set_state(false)
            end
          end
        end
      end
    end
    
    
    def listbox(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::List.new
        @store[component] = []
        component.items.each do |item|
          @store[component] << Gtk::ListItem.new(item)
          #@store[component].show
        end
        @components[component].append_items(@store[component])
        #@components[component].set_selection_mode(Gtk::List::GTK_SELECTION_SINGLE)
        @components[component].signal_connect(Gtk::List::SIGNAL_SELECTION_CHANGED) {
          component.value = @components[component].get_item
          component.change
        }
        @components[component].show_all
      when :update
      
      when :value=
        @components[component].each_with_index do |item, i|
          if item == args[0]
            @components[component].set_item(i)
          end
        end
      end
    end
    
    
#    def droplist(component, message, *args)
#      case message
#      when :new
#        @components[component] = FXComboBox.new(self, 1, component.lines, nil, 0, LAYOUT_FILL_X)
#        @components[component].setEditable(false)
#        component.items.each_with_index do |item, i|
#          @components[component].appendItem(item)
#        end
#        @components[component].connect(SEL_COMMAND) {
#          component.value = @components[component].getItemText(@components[component].getCurrentItem)
#          component.change
#        }
#      when :update
#      
#      when :value=
#        @components[component].each_with_index do |item, i|
#          if item == args[0]
#            @components[component].setCurrentItem(i)
#          end
#        end
#      end
#    end
    
    
    def button(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::Button.new(component.text)
        @components[component].signal_connect(Gtk::Button::SIGNAL_CLICKED) {
          component.press
        }
        @components[component].show
      when :update
      
      end
    end


#    def panel(component, message, *args)
#      case message
#      when :new
#        case component.layout
#        when :grid
#          @components[component] = FXMatrix.new(self, component.body.length, opts=MATRIX_BY_ROWS)
#          # matrix inversion
#          tbody = []
#          component.body.length.times do |y|
#            component.body[y].length.times do |x|
#              tbody[x] = [] unless tbody[x]
#              tbody[x][y] = component.body[y][x]
#            end
#          end
#          tbody.each do |row|
#            row.each do |col_component|
#              @components[col_component].reparent(@components[component])
#            end
#          end
#        end
#      when :update
#      
#      end
#    end
    

    def label(component, message, *args)
      case message
      when :new
        @components[component] = Wise::Label.new(nil, 'text'=>component.text)
        @components[component].show
      when :update
      
      end
    end

    
    def textfield(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::Entry.new #(component.cols, nil, 0, FRAME_NONE)
        @components[component].set_text(component.value)
        @components[component].signal_connect(Gtk::Entry::SIGNAL_CHANGED) { 
          @gate = true
          component.value = @components[component].get_text
          component.change
          @gate = false
        }
        @components[component].show
      when :update
      
      when :value=
        @components[component].set_text(args[0]) if not @gate
      end
    end


    def textarea(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::Text.new
        @components[component].set_editable(true)
        @components[component].insert_text(component.value, 0)
        #@components[component].setVisCols(component.cols)
        #@components[component].setVisRows(component.lines)
        @components[component].signal_connect(Gtk::Text::SIGNAL_CHANGED) { 
          @gate = true
          component.value = @components[component].get_chars(0, -1)
          component.change
          @gate = false
        }
        @components[component].show
      when :update
      
      when :value=
        @components[component].insert_text(args[0], 0) if not @gate
      end
    end
    
    
    def menubar(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::MenuBar.new
        component.items.each do |item|
          @components[component].append(@components[item])
        end
        @components[component].show
      end
    end
    
    
    def menu(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::MenuItem.new(component.text)
        @store[component] = Gtk::Menu.new
        component.items.each do |item|
          @store[component].add(@components[item])
        end
        @components[component].set_submenu(@store[component])
        @store[component].show
        @components[component].show
      end
    end
    
    
    def menuitem(component, message, *args)
      case message
      when :new
        @components[component] = Gtk::MenuItem.new(component.text)
        @components[component].signal_connect(Gtk::MenuItem::SIGNAL_ACTIVATE) {
          component.press
        }
        @components[component].show
      end
    end

  end  # Platform

end  # GUtopIa
