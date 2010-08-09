require 'rubygems'
require 'utility_belt'
require 'yaml'

# Better method to list methods of an object :)
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

# Unix-like functions
# List current directory content, or a directory.
# You can give a symbol to be faster :)
def ls(arg = '*')
  arg = arg.to_s if arg.is_a? Symbol
  if File.directory? arg
    Dir.chdir arg do
      Dir['*']
    end
  else
    Dir[arg]
  end
end

# Change directory to home, or directory given.
# Like ls function, give a symbol to be faster ;)
def cd(arg = nil)
  if arg.nil?
    Dir.chdir
  else
    arg = arg.to_s if arg.is_a? Symbol
    Dir.chdir arg
  end
  Dir.pwd
end

# Where am I?
def pwd
  Dir.pwd
end
