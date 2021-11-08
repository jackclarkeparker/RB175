require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

# This second require here is to ensure that the app reloads its files every
# time we load a page, making development a lot nicer. I.E. don't need to
# constantly restart the server to verify changes.

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.read("data/toc.txt")
  
  erb :home
end

# Here is a difference between this and a straight up rack application;
# The rackup command is run with a config.ru file, and then that file is
# the one that runs the Web application

# Here we don't have to take that intermediate step, instead simply run the web
# app with `ruby` that contains the routes. Simply got to require sinatra in a
# .rb file, and then you gain access to the DSL for defining routes like this:

# get "/" do
#   "Hello World!"
# end

