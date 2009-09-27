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

=begin
Turn you object into automatons!
For an object that is to be bound
every method needs to get a dynamically added trap call
the trap call stores a record of all instance variables
as well as a record of all stated bindings
if an instance variable has changed and a binding exists for it
then it gets called.
=end

module Automagical

  #
  # Method used to bind trigger methods
  # to other methods, and object and class instance variables
  #
  def on(instance, proc=nil, &block)
    proc = block unless proc
    instance = instance.to_s
    ___automate___ unless @___procs___ and @___instances___
    @___procs___[instance] = proc
  end
  
  #
  # Main method for monitoring object state
  # and triggering bound methods
  #
  def ___automata___ #(*args, &block)
    (self.instance_variables | self.class.class_variables).each { |iv|
      if @___instances___.include?(iv)
        current = instance_eval "#{iv}"
      #if ___automatable___(current)
        current = instance_eval "#{iv}"
        if current != @___instances___[iv]
          @___instances___[iv] = current.clone
          if @___procs___.has_key?(iv)
            @___procs___[iv].call(current)
          end
        end
      end
    }
  end
  
  #
  # Setup an object to be monitored
  #
  def ___automate___
    $___trigger___ = []
    @___procs___ = {} unless @___procs___
    @___instances___ = {} unless @___instances___
    (self.instance_variables | self.class.class_variables).each { |iv|
      current = instance_eval "#{iv}"
      if ___automatable___(current)
        @___instances___[iv] = current.clone
      end
    }
    self.methods.each { |meth|
      if not Object.instance_methods(true).include?(meth)
        alias_meth = "___#{meth.hash.to_s.gsub('-', '_')}___"
        if not self.respond_to? alias_meth
          self.instance_eval <<-"EOS"
            class << self
              alias_method :#{alias_meth}, :#{meth}
              def #{meth}(*args, &block)
                return if $___trigger___.include?([self, :#{meth}])
                $___trigger___ << [self, :#{meth}]
                r = send(:#{alias_meth}, *args, &block)
                ___automata___ #(*args, &block)
                if @___procs___.has_key?('#{meth}')
                  @___procs___['#{meth}'].call(*args, &block)
                end
                $___trigger___.pop
                return r
              end
            end
          EOS
        end
      end
    }
  end

  #
  # Determines if an object or class instance variable can be monitored
  #
  def ___automatable___(instance)
    return false if ['@___instances___', '@___procs___'].include?(instance)
    a = false
    a = true if instance.kind_of?(Array) if defined?(Array)
    a = true if instance.kind_of?(Hash) if defined?(Hash)
    a = true if instance.kind_of?(Numeric) if defined?(Numeric)
    a = true if instance.kind_of?(TrueClass) if defined?(TrueClass)
    a = true if instance.kind_of?(FalseClass) if defined?(FalseClass)
    a = true if instance.kind_of?(String) if defined?(String)
    a = true if instance.kind_of?(NilClass) if defined?(NilClass)
    a = true if instance.kind_of?(Range) if defined?(Range)
    a = true if instance.kind_of?(Symbol) if defined?(Symbol)
    a = true if instance.kind_of?(Time) if defined?(Time)
    a = true if instance.kind_of?(Date) if defined?(Date)
    return a
  end

end  # Automagical


class Object
  include Automagical
end


