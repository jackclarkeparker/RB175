class Advice
  def initialize
    @advice_list = [
      "Look deep into nature, and then you will understand everything better.",
      "I have found the paradox, that if you love until it hurts, there can be no more hurt, only more love.",
      "What we think, we become.",
      "Love all, trust a few, do wrong to none.",
      "Oh, my friend, it's not what they take away from you that counts. It's what you do with what you have left.",
      "Lost time is never found again.",
      "Nothing will work unless you do."
    ]
  end

  def generate
    @advice_list.sample
  end
end

=begin
- Because this isn't a separate web app, and only generates content for our existing
  HelloWorld app, it doesn't need a `call` method.
  - It also doesn't need to be required in the rackup config file. Again, it's not
    a webapp, and Rack won't be calling it.

- Where it will need to be required is from the HelloWorld app. This is because
  HelloWorld WILL be calling it, whenever the request_path specifies desire for
  the resource that it provides.
=end