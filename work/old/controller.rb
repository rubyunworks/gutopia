# GUtopIa - Automagical Module
# Copyright (c) 2002 Thomas Sawyer

# GUtopIa is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# GUtopIa is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GUtopIa; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


module Controller

  module Listener
  
    def ___listen___(meth=nil, *args, &block)
      meth = meth.to_s
      if @___events___
        if @___events___.has_key?(meth)
          @___events___[meth].each { |p|
            p.call(*args, &block)
          }
        end
      end
      if @___procs___ and @___state___
        if self != @___state___
          @___state___ = self.clone
          @___procs___.each { |p|
            p.call(self)
          }
        end
      end
    end
  
    def ___automate___
      $___trigger___ = [] unless $___trigger___
      self.methods.each { |meth|
        if not Object.instance_methods(true).include?(meth)
          if not ['when', 'event', 'bind', 'change', '___listen___', '___automate___', '___action___'].include?(meth)
            ___action___(meth)
          end
        end
      }
    end
    
    def ___action___(meth)
      ali = "___#{meth.hash.to_s.gsub('-', '_')}___"
      if not self.respond_to? ali
        self.instance_eval <<-EOS
          class << self
            alias_method :#{ali}, :#{meth}
            def #{meth}(*args, &block)
              return if $___trigger___.include?([self, :#{meth}])
              $___trigger___ << [self, :#{meth}]
              r = send(:#{ali}, *args, &block)
              ___listen___(:#{meth}, *args, &block)
              $___trigger___.pop
              return r
            end
          end
        EOS
      end
    end
    
  end
  
  
  module Methods
  
    include Listener
  
    def when(meth, prc=nil, &block)
      meth = meth.to_s
      ___automate___ unless @___events___
      @___events___ = {} unless @___events___
      prc = block unless prc
      @___events___[meth] = [] unless @___events___[meth]
      @___events___[meth] << prc
    end
  
  end
  
  
  module Variables 
  
    include Listener
  
    def bind(prc=nil, &block)
      ___automate___ unless @___procs___ and @___state___
      @___state___ = self.clone unless @___state___
      @___procs___ = [] unless @___procs___
      prc = block unless prc
      @___procs___ << prc
    end
    
    #alias ___method_added___ method_added if defined?(:Array.method_added)
    #def Array.method_added(id)
      #___method_added___ if defined?(:___method_added___)
      #___action___(id)
    #end
    
    #alias ___singleton_method_added___ method_added if defined?(:singleton_method_added)
    #def Array.singleton_method_added(id)
      #___singleton_method_added___ if defined?(:___method_added___)
      #___action___(id)
    #end
    
  end

end


class Object
  include Controller::Methods
end

class Numeric
  include Controller::Variables
end

class String
  include Controller::Variables
end

class Array
  include Controller::Variables
end

class Hash
  include Controller::Variables
end


