# TODO: work out how to clear redis each time recreate. We did this at YOUhome so take a look.
# TODO: could use Singleton design pattern for test server creation
require File.expand_path( "../test_helper.rb", __FILE__ )

require "timecop"

class RedisStringTest < TestCase

  def setup
    port = 6380
    conf = "redis_test_server.conf"

    # spark up server
    %x(
      redis-server #{conf} --port #{port}
    )

    @redis = Redis.new( :port => port )

    @set = given_a_random_string
    @val1 = given_a_random_string
    @val2 = given_a_random_string
  end

  def test_list_push_and_pop
    # Given # When
    @redis.rpush( @set, [@val1, @val2] )

    # Then
    assert_equal 2, @redis.llen( @set )
    assert_equal [@val1, @val2], @redis.lrange( @set, 0, -1 )

    # And then
    assert_equal @val1, @redis.lpop( @set )
    assert_equal [@val2], @redis.lrange( @set, 0, -1 )

    # And then
    assert_equal @val2, @redis.lpop( @set )
    refute @redis.exists( @set ) # empty lists are removed by Redis
  end

end
