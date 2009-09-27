# GUtopIa - GTK+ Backend Platform
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

require 'gtk'

module GUtopIa

  module Platform
  
    def Platform.initialize
    
    end

    def Platform.start
      Gtk::main
    end
    
    def Platform.stop
      
    end


    class Window < Gtk::Window
    
      def initialize(component)
        @component = component
        super()
        self.set_title(@component.caption)
        case @component.layout
        when :grid
          amatrix = Gtk::Table.new(@component.body.length, @component.body[0].length)
          @component.body.each_with_index do |row, i|
            row.each_with_index do |col_component, j|
              amatrix.attach(col_component.platform_component, j, j+1, i, i+1)
            end
          end
          self.add(amatrix)
          amatrix.show
          #self.show
        end
      end
      
      def show
        super
      end
      
      def hide
        super
      end
      
    end
    
    
    class Panel < Gtk::Frame
      
      def initialize(component)
        @component = component
        super()
        self.set_label(component.caption)
        case component.layout
        when :grid
          amatrix = Gtk::Table.new(@component.body.length, @component.body[0].length)
          @component.body.each_with_index do |row, i|
            row.each_with_index do |col_component, j|
              amatrix.attach(col_component.platform_component, j, j+1, i, i+1)
            end
          end
          self.add(amatrix)
          amatrix.show
          self.show
        end
      end
      
      def show
        super
      end
      
      def hide
        super
      end
      
    end
    
    
    class Button < Gtk::Button
      
      def initialize(component)
        @component = component
        super(@component.text)
        self.signal_connect("pressed") { @component.press }
        self.signal_connect("clicked") { @component.press }
        self.signal_connect("enter")   { @component.pointer_enter }
        self.signal_connect("leave")   { @component.pointer_leave }
        self.show
      end
      
    end
    

    class Label < Gtk::Label
  
      def initialize(component)
        @component = component
        super(component.text)
        self.show
      end
      
    end
    
    
    class Text
    
      def Text.new(component)
        if component.lines <= 1
          return TextSingle.new(component)
        else
          return TextMultiple.new(component)
        end
      end
    
      class TextSingle < Gtk::Entry
    
        def initialize(component)
          @component = component
          super()
          self.set_text(component.value)
          self.signal_connect("changed") { 
            @gate = true
            @component.value = self.get_text
            @component.change
            @gate = false
          }
          self.show
        end
        
        def value=(*args)
          if not @gate
            self.set_text(args[0])
          end
        end
      
      end
      
      class TextMultiple < Gtk::Text
      
        def initialize(component)
          @component = component
          super()
          self.set_editable(true)
          self.insert_text(component.value, 0)
          self.signal_connect(Gtk::Text::SIGNAL_CHANGED) { 
            @gate = true
            component.value = self.get_chars(0, -1)
            component.change
            @gate = false
          }
          self.show
        end
      
        def value=(*args)
          if not @gate
            self.delete_text(0, -1)
            self.insert_text(args[0], 0)
          end
        end
        
      end
    
    end
      

    class TextList < Gtk::Combo
      
      def initialize(component)
        @component = component
        super()
        self.set_popdown_strings(component.items)
        self.signal_connect(Gtk::Combo::SIGNAL_SELECTION_RECEIVED) {
          component.value = self.getItemText(self.getCurrentItem)
          component.change
        }
        self.show
      end
      
      def value=(*args)
        self.each_with_index do |item, i|
          if item == args[0]
            self.setCurrentItem(i)
          end
        end
      end
      
    end
    
    
    class ListBox < Gtk::CList
    
      def initialize(component)
        @component = component
        super(component.columns)
        @items = []
        component.items.each do |item|
          if item.is_a?(Array)
            self.append item
          else
            self.append [item]
          end
        end
        self.signal_connect(Gtk::CList::SIGNAL_SELECT_ROW) {
          self.each_selection { |sel_row|
            puts self.get_row_data(sel_row)
            component.value = self.get_row_data(sel_row)
          }  
          component.change
        }
        self.show_all
      end
      
      def value=(*args)
        self.each_with_index do |item, i|
          if item == args[0]
            self.set_item(i)
          end
        end
      end
      
    end
    
    
    class RadioBox < Gtk::VBox
      
      def initialize(component)
        @component = component
        super()
        @radiobuttons = []
        @component.items.each_with_index do |item, i|
          @radiobuttons[i] = Gtk::RadioButton.new(i==0 ? nil : @radiobuttons[i-1], item)
          @radiobuttons[i].signal_connect(Gtk::RadioButton::SIGNAL_CLICKED) { 
            if @radiobuttons[i].active?
              @gate = true
              component.value = @component.items[i]
              component.change
              @gate = false
            end
          }
          self.add(@radiobuttons[i])
          @radiobuttons[i].show
        end
        self.show
      end
      
      def value=(*args)
        if not @gate
          @items.each do |rb|
            if rb.get_name == args[0]
              rb.set_state(true)
            else
              rb.set_state(false)
            end
          end
        end
      end

    end
    
    
    class MenuBar < Gtk::MenuBar
      
      def initialize(component)
        @component = component
        super()
        component.items.each do |item|
          self.append(item.platform_component)
        end
        self.show
      end
      
    end
    
    
    class Menu < Gtk::MenuItem
      
      def initialize(component)
        @component = component
        super(component.text)
        @submenu = Gtk::Menu.new
        component.items.each do |item|
          @submenu.add(item.platform_component)
        end
        self.set_submenu(@submenu)
        @submenu.show
        self.show
      end
      
    end
    
    
    class MenuItem < Gtk::MenuItem
    
      def initialize(component)
        @component = component
        super(component.text)
        self.signal_connect(Gtk::MenuItem::SIGNAL_ACTIVATE) {
          component.press
        }
        self.show
      end
    end

  end  # Platform

end  # GUtopIa
