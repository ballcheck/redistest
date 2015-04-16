require 'test/unit'
require 'mocha/setup'
require 'byebug'
require "json"
require "redis"

class TestCase < Test::Unit::TestCase
  def given_a_random_string
    SecureRandom.base64
  end

end
