require File.expand_path( "../test_helper.rb", __FILE__ )

class RedisHashTest < RedisTestCase

  def test_set_and_get
    # Given
    @redis.hset( @key, @key1, @val1 )

    # When # Then 
    assert_equal @val1, @redis.hget( @key, @key1 )
  end

  def test_hmset_and_hmget_and_get_all
    # Given
    @redis.hmset( @key, @key1, @val1, @key2, @val2, @key3, @val3 )

    # When # Then 
    assert_equal @val1, @redis.hget( @key, @key1 )
    assert_equal @val2, @redis.hget( @key, @key2 )
    assert_equal @val3, @redis.hget( @key, @key3 )
    assert_equal [ @val1, @val2 ], @redis.hmget( @key, @key1, @key2 )

    assert_equal( { @key1 => @val1, @key2 => @val2, @key3 => @val3 }, @redis.hgetall( @key ) )
  end
end
