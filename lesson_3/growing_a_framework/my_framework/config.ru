require_relative 'app'

run App.new

# Rack config files use the `run` method to say what application we want to run
# on our server.

# The App class acts as our web app and is where most app code will be.
  # We needed to require the file where this class is implemented (app.rb)