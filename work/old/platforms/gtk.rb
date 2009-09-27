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

require 'gutopia/platforms/gtk-dl'

module GUtopIa


  module Platform


    def Platform.initialize
      Gtk.gtk_set_locale()
      argc = [ARGV.length].pack("I")
      argv = ARGV.to_ptr
      if( argv )
        argv = argv.ref
      end
      Gtk.gtk_init(argc, argv)
    end


    def Platform.start
      Gtk.gtk_main()
    end


    def Platform.stop
      Gtk.gtk_main_quit()
    end

  
    class Component
    
      attr_reader :meta, :native
    
      def initialize
      
      end
    
    end


    class Widget < Component
    
      def initialize
        Gtk.gtk_signal_connect(@native, "enter", DLs.callback{signal_enter}, nil)
        Gtk.gtk_signal_connect(@native, "leave", DLs.callback{signal_leave}, nil)
      end
    
      def show
        Gtk.gtk_widget_show(@native)
      end
      
      def hide
        Gtk.gtk_widget_hide(@native)
      end
      
      private
      
      def signal_enter
        p 'signal enter'
        @meta.pointer_enter
      end
      
      def signal_leave
        p 'signal leave'
        @meta.pointer_leave
      end
      
    end


    class Window < Widget
    
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_window_new(Gtk::GTK_WINDOW_TOPLEVEL)
        # attributes
        Gtk.gtk_window_set_title(@native, @meta.caption)
        case @meta.layout
        when :grid
          tablelayout = Gtk.gtk_table_new(@meta.body.length, @meta.body[0].length, false)
          @meta.body.each_with_index do |row, i|
            row.each_with_index do |col_component, j|
              Gtk.gtk_table_attach(tablelayout, col_component.platform_component.native, j, j+1, i, i+1, 0, 0, 0, 0)
            end
          end
          Gtk.gtk_container_add(@native, tablelayout)
          Gtk.gtk_widget_show(tablelayout)
        end
        # events
        Gtk.gtk_signal_connect(@native, "destroy", DLs.callback{signal_destroy}, nil)
        super()
      end
      
      def caption=(chars)
        Gtk.gtk_window_set_title(@native, chars)
      end
      
      private
      
      def signal_destroy
        @meta.close
      end
      
    end
    
    
    class Panel < Widget
      
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_frame_new(component.caption)
        # attributes
        case @meta.layout
        when :grid
          tablelayout = Gtk.gtk_table_new(@meta.body.length, @meta.body[0].length, false)
          @meta.body.each_with_index do |row, i|
            row.each_with_index do |col_component, j|
              Gtk.gtk_table_attach(tablelayout, col_component.platform_component.native, j, j+1, i, i+1, 0, 0, 0, 0)
            end
          end
          Gtk.gtk_container_add(@native, tablelayout)
          Gtk.gtk_widget_show(tablelayout)
        end
        # events
        super()
        Gtk.gtk_widget_show(@native)
      end
      
      def caption=(chars)
        Gtk.gtk_frame_set_label(@native, chars)
      end
      
    end
    
    
    class Button < Widget
      
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_button_new_with_label(@meta.text)
        # attributes
        # events
        Gtk.gtk_signal_connect(@native, "pressed", DLs.callback{signal_pressed}, nil)
        Gtk.gtk_signal_connect(@native, "clicked", DLs.callback{signal_clicked}, nil)
        super()
        Gtk.gtk_widget_show(@native)
      end
      
      private
      
      def signal_pressed
        p 'signal pressed'
        @meta.press
      end
      
      def signal_clicked
        p 'signal clicked'
        @meta.press
      end
      
    end
    

    class Label < Widget
  
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_label_new(@meta.text)
        # attributes
        # events
        super()
        Gtk.gtk_widget_show(@native)
      end
      
      def text=(chars)
        gtk_label_set_text(@native, chars)
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
    
      class TextSingle < Widget
    
        def initialize(component)
          @meta = component
          @native = Gtk.gtk_entry_new_with_max_length(@meta.columns)
          # attributes
          Gtk.gtk_entry_set_text(@native, @meta.value)
          # events
          Gtk.gtk_signal_connect(@native, "changed", DLs.callback{signal_cahnged}, nil)
          super()  
          Gtk.gtk_widget_show(@native)
        end
        
        def value=(*args)
          if not @gate
            self.set_text(args[0])
          end
        end
      
        private
        
        def signal_changed
          @gate = true
          @meta.value = Gtk.gtk_entry_get_text(@native)
          @meta.change
          @gate = false
        end
        
      end
      
      class TextMultiple #< Gtk::Text
      
        def initialize(component)
          @meta = component
          @adjustment = Gtk.gtk_adjustment_new(0, 0, 0, 0, 0, 0)
          @native = Gtk.gtk_label_new(@adjustment)
          #attributes
          Gtk.gtk_text_set_editable(@native, !@meta.readonly)
          Gtk.gtk_text_insert(@native, Gdk.gdk_font_load('courier'), nil, nil, @meta.value, -1)
          #events
          Gtk.gtk_signal_connect(@native, "changed", DLs.callback{signal_changed}, nil)
          super()
          Gtk.gtk_widget_show(@native)
        end
      
        def value=(*args)
          if not @gate
            self.delete_text(0, -1)
            self.insert_text(args[0], 0)
          end
        end
        
        def signal_changed
          @gate = true
          @meta.value = self.get_chars(0, -1)
          @meta.change
          @gate = false
        end
          
      end
    
    end
      

    class TextList < Widget
      
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
      
      private
      
      def signal_selection
        @meta.value = self.getItemText(self.getCurrentItem)
        @meta.change
      end
      
    end
    
    
    class ListBox < Widget
    
      def initialize(component)
        @meta = component
        if @meta.headers.empty?
          Gtk.gtk_clist_new(@meta.columns)
        else
          Gtk.gtk_clist_new_with_title(@meta.columns, @meta.headers)
        end
        # attributes
        @items = []
        @meta.items.each do |item|
          if item.is_a?(Array)
            Gtk.gtk_clist_append(@native, item)
          else
            Gtk.gtk_clist_append(@native, [item])
          end
        end
        # events
        Gtk.gtk_signal_connect(@native, "select-row", DLs.callback{signal_select_row}, nil)
        super()
        Gtk.gtk_widget_show(@native)
      end
      
      def value=(*args)
        self.each_with_index do |item, i|
          if item == args[0]
            self.set_item(i)
          end
        end
      end
      
      private
      
      def signal_select_row
        self.each_selection { |sel_row|
          puts self.get_row_data(sel_row)
          @meta.value = self.get_row_data(sel_row)
        }  
        @meta.change
      end
      
    end
    
    
    class RadioBox < Widget
      
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
    
    
    class MenuBar #< Gtk::MenuBar
      
      def initialize(component)
        @component = component
        super()
        component.items.each do |item|
          self.append(item.platform_component)
        end
        self.show
      end
      
    end
    
    
    class Menu #< Gtk::MenuItem
      
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
    
    
    class MenuItem #< Gtk::MenuItem
    
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
