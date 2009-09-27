# GUtopIa - View
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

require 'gutopia/controller'
require 'gutopia/components'


module GUtopIa

  class View
  
    attr_reader :platform, :components
  
    def initialize(platform=nil, *args)
      if platform
        require "gutopia/platforms/#{platform}"
      end
      @components = []
    end

    def register(&component_map)
      instance_eval(&component_map)
      instance_variables.each do |var|
        instance_eval <<-EOS
          if #{var}.kind_of?(Component)
            @components << #{var}
            def #{var[1..-1]}
              return #{var}
            end
          end
        EOS
      end
    end

    def to_yaml
      yr = ''
      @components.each { |component|
        yr += "\n***\n" + component.to_yaml
        #yr += "\n***\n" + component.inspect
      }
      return yr
    end

  end

end


