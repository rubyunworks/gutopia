# GUtopIa - Application
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

module GUtopIa

  class Application
  
    attr_reader :views
  
    def initialize
      @views = []
    end

    def register(&view_map)
      instance_eval(&view_map)
      instance_variables.each do |var|
        instance_eval <<-EOS
          if #{var}.kind_of?(View)
            @views << #{var}
            def #{var[1..-1]}
              return #{var}
            end
          end
        EOS
      end
    end
    
    def start(&kickstart)
      puts "starting application..."
      Platform.initialize
      @views.each do |view|
        view.components.sort.each do |component|
          component.create
        end
      end
      instance_eval(&kickstart)
      @views.each do |view|
        Platform.start
      end
    end
    
    #def update(&modproc)
    #  instance_eval(&modproc)
    #end
    
    def stop
      Platform.stop
      puts "...application stopped"
      exit
    end

  end
  
end
