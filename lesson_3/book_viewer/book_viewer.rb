require "sinatra"
require "sinatra/reloader"
# This second require here is to ensure that the app reloads its files every
# time we load a page, making development a lot nicer. I.E. don't need to
# constantly restart the server to verify changes.
require "tilt/erubis"

helpers do
  def in_paragraphs(text)
    result = ""
    text.split("\n\n").each do |para|
      result << "<p>#{para}</p>"
    end
    result
  end
end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do  
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  num = params[:number].to_i
  @title = @contents[num - 1]
  @text = File.read("data/chp#{num}.txt")

  redirect "/" unless (1..@contents.size).cover?(num)

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/platypus" do
  erb :platypus, layout: false
end

not_found do
  redirect "/"
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
