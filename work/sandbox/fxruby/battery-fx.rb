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
view = GUtopIa::View.new('gutopia-fx', 'fruitapp', 'psit')
controller = GUtopIa::Controller.new

# define components

      amenuitem  = GUtopIa::MenuItem.new.text('Quit')

           amenu = GUtopIa::Menu.new.text('Menu').items([amenuitem])

        amenubar = GUtopIa::MenuBar.new.items([amenu])

          alabel = GUtopIa::Label.new.text('Label')
     
      atextfield = GUtopIa::TextField.new.value('Text')
       atextarea = GUtopIa::TextArea.new.columns(25).lines(4).readonly(false).value('Multiline Text')

        alistbox = GUtopIa::ListBox.new.lines(3)
        alistbox.items = [ 'One', 'Two', 'Three' ]
        alistbox.value('One')

        adroplist = GUtopIa::DropList.new.lines(6)
        adroplist.items = [ 'One', 'Two', 'Three' ]
        adroplist.value('One')

         abutton = GUtopIa::Button.new.text('Button')
        
          apanel = GUtopIa::Panel.new.layout(:grid)
          apanel.body = [ [ alabel     ],
                          [ alistbox   ],
                          [ adroplist  ],
                          [ atextfield ],
                          [ atextarea  ],
                          [ abutton    ] ]
  
      awindow = GUtopIa::Window.new.caption('A Window').icon('myIcon.ico')
      awindow.menu = amenubar
      awindow.layout(:grid)
      awindow.body = [ [ apanel ] ]


# events
amenuitem.when(:press) { controller.stop }

abutton.when(:press) {
  puts "You pressed the button!"
}


# register the components with the view
view.register {
  @amenuitem = amenuitem
  @amenu = amenu
  @amenubar = amenubar
  @alabel = alabel
  @atextfield = atextfield
  @atextarea = atextarea
  @alistbox = alistbox
  @adroplist = adroplist
  @abutton = abutton
  @apanel = apanel
  @awindow = awindow
}

# register the view with the controller
controller.register {
  @myview = view
}

# start application
controller.start {
  myview.awindow.show
}

#puts
#puts "select about from menu"
#app.widgets['about'].event_selected
#puts "click on close"
#app.widgets['close'].event_pressed
#puts "click on submit"
#app.widgets['submit'].event_pressed
#puts app.widgets['submit'].text
#puts
