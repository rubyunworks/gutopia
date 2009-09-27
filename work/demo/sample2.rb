# GUtopIa - Sample Original (adapted from Rich Kilmer)
# Copyright (c) 2002 Thomas Sawyer, LGPL

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


require 'gutopia/gutopia'

# create model, view and controller
view = GUtopIa::View.new('ruby-gtk')
application = GUtopIa::Application.new

# define components

mi_search  = GUtopIa::MenuItem.new.text('Search')
mi_load = GUtopIa::MenuItem.new.text('Load')
mi_logoff = GUtopIa::MenuItem.new.text('Log Off')

mi_records = GUtopIa::MenuItem.new.text('Records')
mi_templates = GUtopIa::MenuItem.new.text('Templates')
mi_voids = GUtopIa::MenuItem.new.text('Voids')

mi_all = GUtopIa::MenuItem.new.text('ALL')
mi_open = GUtopIa::MenuItem.new.text('Open')
mi_pending = GUtopIa::MenuItem.new.text('Pending')
mi_closed = GUtopIa::MenuItem.new.text('Closed')

mi_10 = GUtopIa::MenuItem.new.text('10')
mi_50 = GUtopIa::MenuItem.new.text('50')
mi_100 = GUtopIa::MenuItem.new.text('100')

m_file = GUtopIa::Menu.new.text('File').items([mi_search, mi_load, mi_logoff])
m_set = GUtopIa::Menu.new.text('Set').items([mi_records, mi_templates, mi_voids])
m_status = GUtopIa::Menu.new.text('Status').items([mi_all, mi_open, mi_pending, mi_closed])
m_max = GUtopIa::Menu.new.text('Max').items([mi_10, mi_50, mi_100])

mb_menubar = GUtopIa::MenuBar.new.items([m_file, m_set, m_status, m_max])

lbl_criteria = GUtopIa::Label.new.text('Criteria:')
t_criteria = GUtopIa::Text.new
lbl_type = GUtopIa::Label.new.text('Type:')
tl_type = GUtopIa::TextList.new.items([])
lbl_sort = GUtopIa::Label.new.text('Sort:')
tl_sort = GUtopIa::TextList.new.items([])

p_selection = GUtopIa::Panel.new.layout(:grid)
p_selection.body = [ [ lbl_criteria, t_criteria, lbl_type, tl_type, lbl_sort, tl_sort ] ]

lb_results = GUtopIa::ListBox.new.columns(5)
lb_results.headers = [ '#', 'Number', 'Identity', 'Description', 'Match' ]

w_search = GUtopIa::Window.new.caption('Search')
w_search.layout(:grid)
w_search.body = [ [ mb_menubar  ], 
                  [ p_selection ],
                  [ lb_results  ] ]

# events
mi_logoff.when(:press) { application.stop }

# register the components with the view
view.register {

  @mi_search = mi_search
  @mi_load = mi_load
  @mi_logoff = mi_logoff
  
  @mi_records = mi_records
  @mi_templates = mi_templates
  @mi_voids = mi_voids

  @mi_all = mi_all
  @mi_open = mi_open
  @mi_pending = mi_pending
  @mi_closed = mi_closed

  @mi_10 = mi_10
  @mi_50 = mi_50
  @mi_100 = mi_100

  @m_file = m_file
  @m_set = m_set
  @m_status = m_status
  @m_max = m_max

  @mb_menubar = mb_menubar

  @lbl_criteria = lbl_criteria
  @t_criteria = t_criteria
  @lbl_type = lbl_type
  @tl_type = tl_type
  @lbl_sort = lbl_sort
  @tl_sort = tl_sort

  @p_selection = p_selection

  @lb_results = lb_results

  @w_search = w_search
}

puts w_search.type

# register the view with the controller
application.register {
  @appview = view
}

# start application
application.start {
  appview.w_search.show
}

