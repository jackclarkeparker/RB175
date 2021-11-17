require "sinatra"
require "sinatra/reloader"
# This second require here is to ensure that the app reloads its files every
# time we load a page, making development a lot nicer. I.E. don't need to
# constantly restart the server to verify changes.
require "tilt/erubis"

require 'pry'
require 'pry-byebug'

helpers do
  def in_paragraphs(text)
    result = ''
    text.split("\n\n").each_with_index do |para, index|
      result << "<p id='#{index + 1}'>#{para}</p>"
    end
    binding.pry
    result
  end

  # def highlight_query_matches(para)
  #   para
  # end
end

def each_chapter
  @contents.each_with_index do |name, idx|
    number = idx + 1
    text = File.read("data/chp#{number}.txt")
    yield name, number, text
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |name, number, text|
    if text.include? query
      matching_paragraphs = find_matching_paragraphs(query, text)
      results << {
        name: name,
        number: number,
        matching_paragraphs: matching_paragraphs
      }
    end
  end

  results
end

def find_matching_paragraphs(query, text)
  matches = []

  text.split("\n\n").each_with_index do |paragraph, idx|
    matches << [paragraph, idx + 1] if paragraph.include?(query)
  end

  matches

  # matches = text.split("/n/n").select do |para|
  #   para.include?(query)
  # end

  # matches.map do |para|
  #   prefix_length = "<p id='".length
  #   id = para[prefix_length...para.index("'", prefix_length)]
  #   [para, id]
  # end
end

=begin

PEDAC for finding_matching_paragraphs

The new feature that we want is to be able to see which paragraphs of a
matching chapter include the query.
- We want to turn these paragraphs into anchor elements themselves, that will
  automatically scroll to the correct portion of the page to display them.
  - We can do this by giving `id` attributes to the paragraphs.

- Does this mean that we need to arrange our text by paragraphs? Like an array
  of paragraphs?
  - Should we therefore backtrack on how we're currently displaying text?
    - No, we're already capturing text in paragraphs. The solution we had
      earlier didn't recognize paragraphs as being paragraphs (when we were
      inserting double line breaks whenever the current line from ::readlines
      was a string consisting of a single newline).
      This would make it harder to provide `id` attributes for actual entire
      paragraphs)
    - Should we provide an `id` that is based on the index of each paragraph?
      - Are there any problems with providing id's that are identical?
        I thought I read somewhere that an id should be unique to an element...
        But maybe there's no issue, because the id's might be the same between
        different chapters, but each chapter will have a different URL?
      - There IS no issue, use the index to provide the id.

- So if we look at the output of `in_paragraphs`, it returns a string
  - We want to be able to select portions of the output
    - Portions whose size is determined by their paragraphing
      - It makes sense to capture paragraphs as separate elements, that is the
        level of discreteness that we want to target.

- Input - String
- Output - String
* id component of the string

- Each string will begin with an opening <p> tag
  - This tag will contain an id attribute
    - The combination of `<p` and `id='` attribute will contain a fixed number
      of characters.
      - If we slice from this index, up till the next quotation mark, then we
        will collect exactly and only the id.

PEDAC for highlight_query_matches

Input - String
* HTML <p> element
Output - String
* The same value as Input, but with `<strong>` tags enclosing all query matches

- Where a query contains more than one word, a match requires that both words
  be present in the same order.
- If the query in it's entirety is present, along with extra characters, this
  still counts as a match.
  - The bold tags must only apply to the portion of the string that matches the
    query; the extra characters must be ignored.
- Where the query is present more than once, shall we apply bold tags to all
  matches? Yes

GENERAL APPROACH

- So I suppose we can find the index of the location of a match, combine this
  with the length of the query, and insert <strong> tags before and after these?
  - How do we ensure we find the index of all matches?
    - If we scan for matches, we will have an array of all the matches


PEDAC for initial search method; for finding and listing chapters that match a
query
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

ADDITIONALLY
By having a method that dedicates itself to yielding information about chapters,
it's easy to modify in one place when we want to expand the range of data we are
collecting. Now we want to capture paragraphs that match, we can make this
another datapoint for the same method.


=end

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do  
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  @title = @contents[number - 1]
  @text = File.read("data/chp#{number}.txt")

  redirect "/" unless (1..@contents.size).cover?(number)

  erb :chapter
end

get "/search" do
  @title = "Search"
  @results = chapters_matching(params[:query])

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
