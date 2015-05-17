require 'test/unit'
require 'mocha/setup'
require 'byebug'
require "json"
require "redis"

class TestCase < Test::Unit::TestCase
  def given_a_random_string
    SecureRandom.base64
  end

  def given_a_random_number
    rand 1000
  end

  def assert_equal_members( a, b )
    assert_equal a.sort, b.sort
  end

end

class RedisTestCase < TestCase

  def setup
    port = 6380
    conf = "redis_test_server.conf"

    # spark up server
    %x(
      redis-server #{conf} --port #{port}
    )

    @redis = Redis.new( :port => port )

    @key =  given_a_random_string << "_key"
    @key1 = given_a_random_string << "_key1"
    @key2 = given_a_random_string << "_key2"
    @key3 = given_a_random_string << "_key3"
    @key4 = given_a_random_string << "_key4"

    @val = given_a_random_string << "_val"
    @val1 = given_a_random_string << "_val1"
    @val2 = given_a_random_string << "_val2"
    @val3 = given_a_random_string << "_val3"
    @val4 = given_a_random_string << "_val4"
  end
end
