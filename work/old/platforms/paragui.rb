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

require 'dl/import'


module ParaGUI

  extend DL::Importable

  dlload "libparagui.so"

  # CONSTANTS
  
  # METHODS
  
  # general
  extern "void* PG_Application()"
  extern "void* PG_Rect(int, int, int, int)"
  
  #extern "void gtk_set_locale()"
  #extern "void gtk_init(void*, void**)"
  #extern "void gtk_main()"
  #extern "void gtk_main_quit()"
  #extern "void gtk_signal_connect(void*, char*, void*, void*)"
  
  #extern "void gtk_widget_show(void*)"
  #extern "void gtk_widget_hide(void*)"
  
  #extern "void gtk_container_add(void*, void*)"
  
  # window
  extern "void* PG_Window(void*, void* , chars*, unsigned long, char*, int)"
  # frame
  # button
  extern "void* PG_Button()"
  # label
  # table layout
  
  # OTHER
  
  def ParaGUI.init
    @@app = pg_application()
    
    #argc = [ARGV.length].pack("I")
    #argv = ARGV.to_ptr
    #if( argv )
    #  argv = argv.ref
    #end
    #gtk_init(argc, argv)
  end
  
  def ParaGUI.start
    gtk_main()
  end
  
  def ParaGUI.invoke(proc)
    proc.call
  end
  
  def quit
    gtk_main_quit()
  end
  
  CB_QUIT = callback "void quit(void*, void*)"
  
end


module GUtopIa

  module Platform

    def Platform.initialize
      Gtk.init
    end

    def Platform.start
      Gtk.start
    end
    
    def Platform.stop
      Gtk.quit
    end


    class Component
    
      attr_reader :meta, :native
    
    end


    class Widget < Component
    
      def show
        Gtk.gtk_widget_show(@native)
      end
      
      def hide
        Gtk.gtk_widget_hide(@native)
      end
      
    end


    class Window < Widget
    
      attr_reader :meta, :native
    
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_window_new(Gtk::GTK_WINDOW_TOPLEVEL)
        # events
        Gtk.gtk_signal_connect(@native, "destroy", Gtk.invoke(proc { @meta.close }), nil)
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
      end
      
      def caption=(chars)
        Gtk.gtk_window_set_title(@native, chars)
      end
      
    end
    
    
    class Panel < Widget
      
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_frame_new(component.caption)
        # events
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
        
        Gtk.gtk_widget_show(@native)
      end
      
      def caption=(chars)
        Gtk.gtk_frame_set_label(@native, chars)
      end
      
    end
    
    
    class Button < Widget
      
      attr_reader :meta, :native
      
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_button_new_with_label(@meta.text)
        # events
        Gtk.gtk_signal_connect(@native, "pressed", proc { @meta.press }, nil)
        Gtk.gtk_signal_connect(@native, "clicked", proc { @meta.press }, nil)
        Gtk.gtk_signal_connect(@native, "enter", proc { @meta.pointer_enter }, nil)
        Gtk.gtk_signal_connect(@native, "leave", proc { @meta.pointer_leave }, nil)
        # attributes
        
        Gtk.gtk_widget_show(@native)
      end
      
    end
    

    class Label < Widget
  
      attr_reader :meta, :native
  
      def initialize(component)
        @meta = component
        @native = Gtk.gtk_label_new(@meta.text)
        # events
        # attributes
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
    
      class TextSingle #< Gtk::Entry
    
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
      
      class TextMultiple #< Gtk::Text
      
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
      

    class TextList #< Gtk::Combo
      
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
    
    
    class ListBox #< Gtk::CList
    
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
    
    
    class RadioBox #< Gtk::VBox
      
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
