require 'rubygems'
require 'utility_belt'
require 'yaml'

# http://rbjl.net/31-the-multi-mega-method-list
module Kernel
  def method_list(levels = 1)
    if self.is_a? Module
      klass, method_function = self, :public_methods
    else
      klass, method_function = self.class, :public_instance_methods

      eigen = self.singleton_methods
      if !eigen.empty?
        puts :Eigenclass # sorry for not being up to date, I just love the word
        puts self.singleton_methods.sort.to_yaml
      end
    end

    levels.times{ |level|
      if cur = klass.ancestors[level]
        puts cur # put class name
        puts cur.send(method_function, false).to_yaml # put methods of the class
      else
        break
      end
    }

    self # or whatever
  end

  alias mm method_list
end
