require_relative 'app'

run App.new

# Rack config files use the `run` method to say what application we want to run
# on our server.
  # Could we say that invoking `run` and passing in an instance of the given
  # web app class (whether it be App or HelloWorld) means that #call will be
  # invoked on that instance?

# The App class acts as our web app and is where most app code will be.
  # We needed to require the file where this class is implemented (app.rb)