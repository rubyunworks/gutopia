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

# define label
alabel = GUtopIa::Label.new.text('Hello World')

# define button
abutton = GUtopIa::Button.new.text('Click Me')

# define window
awindow = GUtopIa::Window.new.caption('My Cool Window').icon('myIcon.ico')
awindow.layout(:grid)
awindow.body = [ [ alabel  ],
                 [ abutton ] ]

# bindings
awindow.when(:close) { application.stop }

# register the components with the view
view.register {
  @awindow = awindow
  @alabel = alabel
  @abutton = abutton
}

# register the view with the controller
application.register {
  @myview = view
}

# start application
application.start {
  myview.awindow.show
}
