require_relative 'advice'

class App
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {'Content-Type' => 'text/html'}, [erb(:index)]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {'Content-Type' => 'text/html'},
        [erb(:advice, message: piece_of_advice)]
      ]
    else
      [
        '404',
        {'Content-Type' => 'text/html', 'Content-Length' => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end

  private

  def erb(filename, local = {})
    # b = binding
    # message = local[:message]
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result
  end
end

=begin
A rack application, because this is run from a config.ru file, the HelloWorld
class contains a call(env) method, which returns the required 3 element array.

As a reminder, the final element can be anything that responds to `each` that
yields a string. Here an array is the simplest option to use.
=end