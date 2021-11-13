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

  def search_matches
    matches = (1..@contents.size).to_a
    matches.select do |num|
      chapter_text = File.read("data/chp#{num}.txt")
      chapter_text.downcase.include?(params[:query].downcase)
    end
  end
end

=begin

PEDAC

QUESTIONS

Q Where should the HTML be written for matches?
A - in the erb file
Q Are queries case sensitive?
A - No


Input - query
Output - Array of integers
* Either a heading and list of matches for those chapters where the query is matched,
  or a short description explaining that no matches exist.

IDEAS

We have this idea that we can iterate through all of the chapters
  - We'll be able to do this because we can use the size of the `@chapters` array,
    and rely on the common formatting of the chp(n).txt files to successfully
    iterate through all those files that must be searched through.
  - What will be returned?
    - An array
      - What will the array consist of?
        - The name of each chapter?
          - This to display the name
        - The position of each chapter in the contents
          - This to capture the value needed for the route to the chapter
          - We can use this to ascertain the name.
        - subarr's that contain the chapter's name as well as it's position?

        - We can try each of these out! ^^^


How do we find a match?
  - String#include? 

1. Initialise `matches` to an empty array
2. Iterate through the numbers 1 through the length of `@contents`, referencing
   the current number as `num`
   - Initialise `chapter_text` to the contents of the file whose name is chp<num>.txt
   - Check to see whether a downcase version of the query is present in a downcase
     version of `chapter_text`
     - If so, append `num` to `matches`


3. If `matches` is an empty array, return a paragraph tag stating that no
   matches could be found.
4. Otherwise, return HTML that begins with
   - A H2 tag, reading "Results for <query>"
   - An unordered list of each of the chapters that are matched



LOOK TO REFACTOR AFTER FIRST ATTEMPT

Thoughts

My solution just grabbed the chapter numbers, and used these to ascertain the
name (number - 1 gives index of title from @contents), and path (data/chp<num>.txt)
for each chapter.

LS's solution used two top-level methods, as well as a very similarly written
conditional for `views/search.erb`.

The first of LS's top-level methods worked do collect the number (for path), name
(for display), and contents (to check whether it included the query) of each
chapter, and yielded these to a block. The each_with_index method was used to
grab the name and number (by adding 1 to the index), and the contents was read
using File.read and the number.

The second method was simply a selection method, that collected results in an array.
It first performed a check that would return the array empty if the query was
nil (non existent), or empty.
If it wasn't, it called the previous method, and collected the number and name of
matching results as hash elements to store in the results array.
The nice thing about this was that it was very clear what was being used in the
search array later, we weren't referencing elements at numbered indexes from
`contents` when grabbing the title of each matching chapter, they're referenced
by Launch School as result[:name]

Learning is this: If you're going to be referencing a number of data-points
relating to some sort of object, it may be useful to capture them as name-value
pairs so that their presence is self-explanatory when you reference them.

=end

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

get "/search" do
  erb :search
end

not_found do
  redirect "/"
end

# get "/show/:name" do
#   params[:name]
# end

# get "/platypus" do
#   erb :platypus, layout: false
# end



# Here is a difference between this and a straight up rack application;
# The rackup command is run with a config.ru file, and then that file is
# the one that runs the Web application

# Here we don't have to take that intermediate step, instead simply run the web
# app with `ruby` that contains the routes. Simply got to require sinatra in a
# .rb file, and then you gain access to the DSL for defining routes like this:

# get "/" do
#   "Hello World!"
# end
