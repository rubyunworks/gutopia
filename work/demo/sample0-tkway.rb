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

quit = GUtopIa::MenuItem.new { text 'Quit' }
about = GUtopIa::MenuItem.new { text 'About' }
file = GUtopIa::Menu.new { text 'File'; items [quit] }
help = GUtopIa::Menu.new { text 'Help'; items [about] }
menu = GUtopIa::MenuBar.new { items [file, help] }

firstNamelbl = GUtopIa::Label.new { text 'First Name' }
lastNamelbl = GUtopIa::Label.new { text 'Last Name' }
favoriteFruitlbl = GUtopIa::Label.new { text 'Favorite Fruit' }

firstName = GUtopIa::Text.new
lastName = GUtopIa::Text.new
favoriteFruit = GUtopIa::Text.new { columns 25; lines 4; readonly false; value 'Banana' }

submitbtn = GUtopIa::Button.new { text 'Update'; image 'check.png' }
clearbtn = GUtopIa::Button.new { text 'Clear' }

fruit_panel = GUtopIa::Panel.new {
  layout :grid
  body   [ [ firstNamelbl,     firstName     ],
           [ lastNamelbl,      lastName      ],
           [ favoriteFruitlbl, favoriteFruit ],
           [ submitbtn,        clearbtn      ] ]
}
      
mainWindow = GUtopIa::Window.new { 
  caption 'My Cool Window'
  icon    'myIcon.ico'
  layout  :grid
  body    [ [ menu        ],
            [ fruit_panel ] ]
}
      
aboutlbl = GUtopIa::Label.new {
  text "This is a very cool application\n"  \
       "that I created using the GUtopIa\n" \
       "GUI API."
}
        
closebtn = GUtopIa::Button.new { text 'Close' }
  
aboutWindow = GUtopIa::Window.new {
  caption 'About My Cool App'
  layout  :grid
  body    [ [ aboutlbl ],
            [ closebtn ] ]
}


# events
quit.when(:press) { application.stop }
about.when(:press) { aboutWindow.show }

submitbtn.when(:press) {
  puts "And the fruit is...#{favoriteFruit.value}"
  mainWindow.hide
  application.stop
}

clearbtn.when(:press) { favoriteFruit.value = '' }

closebtn.when(:press) { aboutWindow.hide }


# register the components with the view
view.register {
  @quit = quit
  @about = about
  @file = file
  @help = help
  @menu = menu
  @firstNamelbl = firstNamelbl
  @lastNamelbl = lastNamelbl
  @favoriteFruitlbl = favoriteFruitlbl
  @firstName = firstName
  @lastName = lastName
  @favoriteFruit = favoriteFruit
  @submitbtn = submitbtn
  @clearbtn = clearbtn
  @fruit_panel = fruit_panel
  @mainWindow = mainWindow
  @aboutlbl = aboutlbl
  @closebtn = closebtn
  @aboutWindow = aboutWindow
}

# register the view with the application
application.register {
  @myview = view
}

# start application
application.start {
  myview.mainWindow.show
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
