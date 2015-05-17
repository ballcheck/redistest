# TODO: work out how to clear redis each time recreate. We did this at YOUhome so take a look.
# TODO: could use Singleton design pattern for test server creation
require File.expand_path( "../test_helper.rb", __FILE__ )

require "timecop"

class RedisStringTest < RedisTestCase

  def test_list_push_and_pop_and_len
    # Given # When
    @redis.rpush( @key, [@val1, @val2] )

    # Then
    assert_equal 2, @redis.llen( @key )
    assert_equal [@val1, @val2], @redis.lrange( @key, 0, -1 )

    # And then
    assert_equal @val1, @redis.lpop( @key )
    assert_equal [@val2], @redis.lrange( @key, 0, -1 )

    # And then
    assert_equal @val2, @redis.lpop( @key )
    refute @redis.exists( @key ) # empty lists are removed by Redis
  end

  def test_list_range_and_trim
    # Given
    list = 10.times.map{ given_a_random_string }

    # When
    @redis.rpush( @key, list )

    # Then
    assert_equal list, @redis.lrange( @key, 0, -1 )
    assert_equal list[0..5], @redis.lrange( @key, 0, 5 )

    # and When
    @redis.ltrim( @key, 3, 8 )

    # Then
    assert_equal list[3..8], @redis.lrange( @key, 0, -1 )
  end

  def test_rpop_lpush
    # Given
    key1 = given_a_random_string
    key2 = given_a_random_string
    list = %w{this is a test! testing 1, 2, 3}

    @redis.rpush key1, list

    assert_equal list, @redis.lrange( key1, 0, -1 )
    assert_equal [], @redis.lrange( key2, 0, -1 )

    # When
    @redis.rpoplpush( key1, key2 )
    
    # Then 
    assert_equal list[0..-2], @redis.lrange( key1, 0, -1 )
    assert_equal [ list[-1] ], @redis.lrange( key2, 0, -1 )
  end


end
