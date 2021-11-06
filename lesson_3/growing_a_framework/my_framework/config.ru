require_relative 'hello_world'

run HelloWorld.new

# Rack config files use the `run` method to say what application we want to run
# on our server.

# The HelloWorld class acts as our web app and is where most app code will be.
  # We needed to require the file where this class is implemented (hello_world.rb)