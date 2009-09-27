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

# create model, view and application
view = GUtopIa::View.new('ruby-gtk')
application = GUtopIa::Application.new

# define components

      amenuitem  = GUtopIa::MenuItem.new.text('Quit')
           amenu = GUtopIa::Menu.new.text('Menu').items([amenuitem])
        amenubar = GUtopIa::MenuBar.new.items([amenu])

          alabel = GUtopIa::Label.new.text('Label')
     
      atextfield = GUtopIa::Text.new.value('Text')
       atextarea = GUtopIa::Text.new.columns(25).lines(4).readonly(false).value('Multiline Text')

       aradiobox = GUtopIa::RadioBox.new
       aradiobox.items = [ '1', '2', '3' ]
       aradiobox.value('One')

        alistbox = GUtopIa::ListBox.new.lines(3)
        alistbox.items = [ 'One', 'Two', 'Three' ]
        alistbox.value('One')

        adroplist = GUtopIa::TextList.new.lines(6)
        adroplist.items = [ 'A', 'B', 'C' ]
        adroplist.value('One')

         abutton = GUtopIa::Button.new.text('Button')
        
#          apanel = GUtopIa::Panel.new.layout(:grid)
#          apanel.body = [ [ alabel     ],
#                          [ alistbox   ],
#                          [ adroplist  ],
#                          [ atextfield ],
#                          [ atextarea  ],
#                          [ abutton    ] ]
  
      awindow = GUtopIa::Window.new.caption('A Window').icon('myIcon.ico')
      awindow.layout(:grid)
      awindow.body = [ [ amenubar   ],
                       [ alabel     ],
                       [ abutton    ],
                       [ atextfield ],
                       [ atextarea  ],
                       [ aradiobox  ],
                       [ adroplist  ],
                       [ alistbox   ] ]


# events
#amenuitem.when(:press) { application.stop }

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
  @aradiobox = aradiobox
  @alistbox = alistbox
  @adroplist = adroplist
  @abutton = abutton
#  @apanel = apanel
  @awindow = awindow
}

# register the view with the application
application.register {
  @myview = view
}

# start application
application.start {
  myview.awindow.show
}
