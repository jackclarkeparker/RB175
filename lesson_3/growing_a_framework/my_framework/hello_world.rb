class HelloWorld
  def call(env)
    ['200', {'Content-Type' => 'text/plan'}, ["Hello World!\n"]]
  end
end

=begin
A rack application, because this is run from a config.ru file, the HelloWorld
class contains a call(env) method, which returns the required 3 element array.

As a reminder, the final element can be anything that responds to each that
yields a string. Here an array is the simplest option to use.
=end