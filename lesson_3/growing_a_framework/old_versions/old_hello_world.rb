require_relative 'advice'     # loads advice.rb

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      template = File.read("views/index.erb")
      content = ERB.new(template)
      ['200', {'Content-Type' => 'text/html'}, [content.result]]
      # I wonder why we use an ERB object here when we could just straight up
      # use the string from File::read 'ing the .erb file? could be `template`,
      # or could be `File.read("views/index.erb")` itself
    when '/advice'
      piece_of_advice = Advice.new.generate   # random piece of advice
      [
        '200',
        {'Content-Type' => 'text/html'},
        ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
      ]
    else
      [
        '404',
        {'Content-Type' => 'text/html', 'Content-Length' => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end
end

=begin
A rack application, because this is run from a config.ru file, the HelloWorld
class contains a call(env) method, which returns the required 3 element array.

As a reminder, the final element can be anything that responds to `each` that
yields a string. Here an array is the simplest option to use.
=end
