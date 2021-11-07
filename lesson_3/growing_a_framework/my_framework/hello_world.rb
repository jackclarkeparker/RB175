require_relative 'advice'     # loads advice.rb

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {'Content-Type' => 'text/plan'}, ["Hello World!\n"]]
    when '/advice'
      piece_of_advice = Advice.new.generate   # random piece of advice
      ['200', {'Content-Type' => 'text/plan'}, [piece_of_advice + "\n"]]
    else
      [
        '404',
        {'Content-Type' => 'text/plain', 'Content-Length' => '13'},
        ['404 Not Found']
      ]
    end
  end
end

=begin
A rack application, because this is run from a config.ru file, the HelloWorld
class contains a call(env) method, which returns the required 3 element array.

As a reminder, the final element can be anything that responds to each that
yields a string. Here an array is the simplest option to use.
=end
