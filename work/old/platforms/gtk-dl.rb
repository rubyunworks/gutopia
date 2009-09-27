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
require 'dl/struct'


module GUtopIa


  module DLs
  
    def DLs.callback(prc=nil, &block)
      prc = block unless prc
      return DL.callback('0PP', prc)
    end
    
  end
  
  
  module Gdk
  
    extend DL::Importable
    dlload "libgdk.so"
  
  # gdk/gdktypes.h
  
    GdkColor = struct [
     "long pixel",
     "short red",
     "short green",
     "short blue",
    ]

  #
  
    # GdkFont*      gdk_font_load            (const gchar *font_name);
    # GdkColormap*  gdk_colormap_get_system  (void);
    
    extern "void* gdk_font_load(chars*)"
    extern "void* gdk_colormap_get_system()"
    
  end


  module Gtk
  
    extend DL::Importable
    dlload "libgtk.so"
  
  # gtk/gtkenums.h
    
    GTK_WINDOW_TYPE = [
      GTK_WINDOW_TOPLEVEL = 0,
      GTK_WINDOW_DIALOG   = 1,
      GTK_WINDOW_POPUP    = 2,
    ]
  
  # general
    
    #
    extern "void gtk_set_locale()"
    
    #
    extern "void gtk_init(void*, void**)"
    
    #
    extern "void gtk_main()"
    
    #
    extern "void gtk_main_quit()"
    
    #
    extern "void gtk_signal_connect(void*, char*, void*, void*)"
    
    #
    extern "void gtk_widget_show(void*)"
    
    #
    extern "void gtk_widget_hide(void*)"
    
    #
    extern "void gtk_container_add(void*, void*)"
  
  # table layout
    
    #
    extern "void* gtk_table_new(int, int, ibool)"
    
    #
    extern "void gtk_table_attach(void*, void*, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int, unsigned int)"  
  
  # window
    
    #
    extern "void* gtk_window_new(int)"
    
    #
    extern "void gtk_window_set_title(void*, char*)"
    
    #
    extern "void gtk_window_set_default_size(void*, int, int)" 
  
  # frame
    
    #
    extern "void* gtk_frame_new(char*)"
    
    #
    extern "void gtk_frame_set_label(void*, char*)"
    
    #
    extern "void gtk_frame_set_label_align(void*, float, float)"
    
    #
    extern "void gtk_frame_set_shadow_type(void*, int)" # n/a?
  
  # button
    
    #
    extern "void* gtk_button_new_with_label(char*)"
    
  # label
  
    #  
    extern "void* gtk_label_new(char*)"
    
    #
    extern "void gtk_label_set_text(void*, char*)"
  
  # entry
    
    #  
    extern "void* gtk_entry_new_with_max_length(int)"
    
    #
    extern "void gtk_entry_set_text(void*, chars*)"
    
    #
    extern "char* gtk_entry_get_text(void*)"
  
  # text
    
    #
    extern "void* gtk_adjustment_new(float, float, float, float, float, float)"
    
    #
    extern "void* gtk_text_new(void*, void*)"
    
    #
    extern "void gtk_text_set_editable(void*, ibool)"
  
    # void gtk_text_insert (GtkText *text, GdkFont *font, GdkColor *fore, GdkColor *back, const char *chars, gint length);
    extern "void gtk_text_insert(void*, void*, void*, void*, chars*, int)"
  
  # combo
  
    # GtkWidget* gtk_combo_new (void);
    extern "void* gtk_combo_new()"
    
    # void gtk_combo_set_popdown_strings (GtkCombo *combo, GList *strings);
    extern "void gtk_combo_set_popdown_strings(void*, void*)"
  
  # list
  
    # struct       GtkList;
    # GtkWidget*   gtk_list_new                    (void);
    # void         gtk_list_insert_items           (GtkList *list, GList *items, gint position);
    # void         gtk_list_append_items           (GtkList *list, GList *items);
    # void         gtk_list_prepend_items          (GtkList *list, GList *items);
    # void         gtk_list_remove_items           (GtkList *list, GList *items);
    # void         gtk_list_remove_items_no_unref  (GtkList *list, GList *items);
    # void         gtk_list_clear_items            (GtkList *list, gint start, gint end);
    # void         gtk_list_select_item            (GtkList *list, gint item);
    # void         gtk_list_unselect_item          (GtkList *list, gint item);
    # void         gtk_list_select_child           (GtkList *list, GtkWidget *child);
    # void         gtk_list_unselect_child         (GtkList *list, GtkWidget *child);
    # gint         gtk_list_child_position         (GtkList *list, GtkWidget *child);
    # void         gtk_list_set_selection_mode     (GtkList *list, GtkSelectionMode mode);
    # void         gtk_list_extend_selection       (GtkList *list, GtkScrollType scroll_type, gfloat position, gboolean auto_start_selection);
    # void         gtk_list_start_selection        (GtkList *list);
    # void         gtk_list_end_selection          (GtkList *list);
    # void         gtk_list_select_all             (GtkList *list);
    # void         gtk_list_unselect_all           (GtkList *list);
    # void         gtk_list_scroll_horizontal      (GtkList *list, GtkScrollType scroll_type, gfloat position);
    # void         gtk_list_scroll_vertical        (GtkList *list, GtkScrollType scroll_type, gfloat position);
    # void         gtk_list_toggle_add_mode        (GtkList *list);
    # void         gtk_list_toggle_focus_row       (GtkList *list);
    # void         gtk_list_toggle_row             (GtkList *list, GtkWidget *item);
    # void         gtk_list_undo_selection         (GtkList *list);
    # void         gtk_list_end_drag_selection     (GtkList *list);

    extern "void*  gtk_list_new()"
    extern "void   gtk_list_insert_items           (void*, GList *items, int)"
    extern "void   gtk_list_append_items           (void*, GList *items)"
    extern "void   gtk_list_prepend_items          (void*, GList *items)"
    extern "void   gtk_list_remove_items           (void*, GList *items)"
    extern "void   gtk_list_remove_items_no_unref  (void*, GList *items)"
    extern "void   gtk_list_clear_items            (void*, int, int)"
    extern "void   gtk_list_select_item            (void*, int)"
    extern "void   gtk_list_unselect_item          (void*, int)"
    extern "void   gtk_list_select_child           (void*, void*)"
    extern "void   gtk_list_unselect_child         (void*, void*)"
    extern "int    gtk_list_child_position         (void*, void*)"
    extern "void   gtk_list_set_selection_mode     (void*, GtkSelectionMode mode)"
    extern "void   gtk_list_extend_selection       (void*, GtkScrollType scroll_type, gfloat, ibool)"
    extern "void   gtk_list_start_selection        (void*)"
    extern "void   gtk_list_end_selection          (void*)"
    extern "void   gtk_list_select_all             (void*)"
    extern "void   gtk_list_unselect_all           (void*)"
    extern "void   gtk_list_scroll_horizontal      (void*, GtkScrollType scroll_type, float)"
    extern "void   gtk_list_scroll_vertical        (void*, GtkScrollType scroll_type, float)"
    extern "void   gtk_list_toggle_add_mode        (void*)"
    extern "void   gtk_list_toggle_focus_row       (void*)"
    extern "void   gtk_list_toggle_row             (void*, void*)"
    extern "void   gtk_list_undo_selection         (void*)"
    extern "void   gtk_list_end_drag_selection     (void*)"

  
  
  # clist
    
    # GtkWidget* gtk_clist_new (gint columns);
    extern "void* gtk_clist_new(int)"
    
    # GtkWidget* gtk_clist_new_with_titles (gint columns, gchar *titles[]);
    extern "void* gtk_clist_new_with_titles(int, chars*[])"
    
    # gint gtk_clist_append (GtkCList *clist, gchar *text[]);
    extern "int gtk_clist_append (void*, chars*[])"
    
  end
  
end
