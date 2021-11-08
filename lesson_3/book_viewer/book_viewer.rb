require "sinatra"
require "sinatra/reloader"
# This second require here is to ensure that the app reloads its files every
# time we load a page, making development a lot nicer. I.E. don't need to
# constantly restart the server to verify changes.
require "tilt/erubis"



get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")

  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @text = File.readlines("data/chp1.txt")

  erb :chapter
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
