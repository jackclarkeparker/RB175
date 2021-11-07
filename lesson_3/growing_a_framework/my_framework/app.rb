require_relative 'monroe'
require_relative 'advice'

class App < Monroe
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = '200'
      headers = {'Content-Type' => 'text/html'}
      response(status, headers) do 
        erb :index
      end
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = '200'
      headers = {'Content-Type' => 'text/html'}
      response(status, headers) do
        erb :advice, message: piece_of_advice
      end
    else
      status = '404'
      headers = {'Content-Type' => 'text/html', 'Content-Length' => '60'}
      response(status, headers) do
        erb :not_found
      end
    end
  end
end

=begin
A rack application, because this is run from a config.ru file, the HelloWorld
class contains a call(env) method, which returns the required 3 element array.

As a reminder, the final element can be anything that responds to `each` that
yields a string. Here an array is the simplest option to use.
=end