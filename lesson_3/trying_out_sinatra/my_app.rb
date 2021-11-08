require 'sinatra'

get '/' do
  'Hello world!'
end

get '/blah' do
  '<html><body><p>I believe I can flyyyy</p></body></html>'
end

# Here are two get routes. They will response to GET requests that use that
# match their respective patterns ('/' and '/blah')

# If you start a route with a different http method, i.e. post, put, patch...
# It will respond to those respective requests (that match the given pattern)

# Routes are matched in the order they are defined. First route that matches
# the request is invoked.