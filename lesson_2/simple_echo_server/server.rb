require "socket"

server = TCPServer.new("localhost", 3003)

# def dice_values(rolls, sides)
#   rolls = rolls.to_i
#   sides = sides.to_i
#   return "" if rolls < 1 || sides < 1

#   results = []
#   rolls.times { results << (rand(sides) + 1) }
#   results.join(' ')
# end

def parse_request(request_line)
  http_method, path_and_query, http_version = request_line.split
  path, query = path_and_query.split('?')
  
  params = query.split('&')
  params.map! { |param| param.split('=') }
  params = params.to_h

  [http_method, path, params]
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  client.puts "HTTP/1.1 200 OK\r\n\r\n"
  puts request_line

  http_method, path, params = parse_request(request_line)

  rolls = params['rolls'].to_i
  sides = params['sides'].to_i
  dice_results = []

  rolls.times { dice_results << (rand(sides) + 1) }
  dice_results = dice_results.join(' ')

  client.puts request_line
  client.puts dice_results 
  # client.puts dice_values(params['rolls'], params['sides'])

  client.close
end

=begin
  
THINGS I HAVE LEARNT:
- It was good to place the method definition outside the loop!
- LS chose to leave the logic for generating dice_results inside
  the loop; didn't extract to a method.
  - (The method they are placing outside the loop is for parsing the request line)

  --- HEHE, so I extracted the logic for generating dice results into a method,
      leaving the request_line parser in the general loop logic.
      LAUNCH SCHOOL reasoned that the request_line parser is more useful and will
      be reused.! ¡HaH!

  - I thought binding.pry wasn't working, but it actually was.
    Not sure what mental model of mine was off there.
=end



=begin

PEDAC

Extract components from request_line
------------------------------------

split the string

The first element is the http_method
The second element, split by the `?` (into the path, and params)

params = "rolls=2&sides=6"

params split by `&`

["rolls=2", 'sides=6']

Iterate through and split by `=`

[['rolls', '2'], ['sides', '6']]


Implement dice roller
---------------------

Questions

Q) Do we want for our method to return rolled dice to then be printed out by client.puts?
-> I think so, because this means our method is concerning itself with generating the rolled dice, not printing them
-> Makes it easier to understand what the code is doing by keeping responsibilities separate.

Q) What does the method return?
- If I return an array, then each die will be printed on a separate line by `client.puts`
- I could return a string with each die represented, and pass this to params?

Q) Do we need to handle inputs below 4 sides?
- Below 4 sides is an invalid die. But we're not trying to write the rules of dice. 
- Don't worry about handling inputs like this for now
----> For now we'll not worry about the size limit of the die, or the number being rolled. No limits.
  - What about inputs that are less than 1?
  ---> If either number is less than 1, return an empty string

Input - Two strings
* (Numerical strings) Representing how many dice to roll and how many sides per die
Output - Returned String
* Contains `rolls` numbers separated by whitespace, with each number being a random number between 1 and `sides`.

Shall we implement a smaller method to generate the random number?

Let's just work out the algorithm first

EXAMPLES

I dice_values(4, 20)
O "13 4 6 18"

I dice_values(0, 0)
O ""

I dice_values(-342, 4536)
O ""

I dice_values(34255, -345)
O ""

DATA STRUCTURE / Approach

We have a rolls value, and a sides value.
OPTION I suppose these could be passed in as integers, if to_i was called as they are passed in as arguments.

If either number is less than 1, we just return an empty string

ALGORITHM

INPUT - Integer `rolls`, Integer `sides`

1. Return an empty string if `rolls` or `sides` is less than 1
2. Initialise `results` to an empty array
3. iterate `rolls` times
   - append `results` with a random number between 1 and `sides`
4. Join results by whitespace

=end

