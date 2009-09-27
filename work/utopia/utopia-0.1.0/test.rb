  require 'utopia'
  
  app = Utopia.new_application("My Application")
  
  aboutWindow = nil
  mainWindow = nil
  
  mainWindow = app.modeller.build(:window).title("My Cool Window").body {
    icon(:icon).file('myIcon.ico')
    menu(:menubar).items {
      file(:menu).text('File').items {
        quit(:menuitem).text('Quit').bind_event(:selected) do
          app.controller.stop
        end
      }
      help(:menu).text('Help').items {
        about(:menuitem).text('About').bind_event(:selected) do
          app.controller.show aboutWindow
        end
      }
    }
    fruit_panel(:panel).body {
      firstName(:textfield).label("First name:").label_position(:left)
      lastName(:textfield).label("Last name:").label_position(:left)
      favoriteFruit(:textarea).cols(5).lines(4).readonly(false).label("Favorite Fruit:").label_position(:top)
      submit(:button).text('Update').image('check.png').bind_event(:pressed) do 
        app.controller.alert "And the fruit is....#{favoriteFruit.text}"
        app.controller.hide mainWindow
        app.controller.end
      end
      clear(:button).text('Clear').bind_event(:pressed) do
        favoriteFruit.text=nil
      end
    }
  }
  
  aboutWindow = app.modeller.build(:window).title("About My Cool App").body {
    about(:label).text = <<-DATA
    This is a very cool application
    that I created using the Utopia
    GUI API.
    DATA
    close(:button).text("Close").bind_event(:pressed) do
      app.controller.hide aboutWindow
    end
  }
  
  app.controller.start {
    show mainWindow
  }

puts "click on about"
mainWindow.body.menu.items.help.items.about.fire_event(:selected)
puts "click on close"
aboutWindow.body.close.fire_event(:pressed)
puts "select close from menu"
mainWindow.body.menu.items.file.items.quit.fire_event(:selected)
