require File.expand_path( "../test_helper.rb", __FILE__ )

class RedisMiscTest < RedisTestCase

  def test_non_existant_keys_return_different_data_types
    # Given
    refute @redis.exists( @key )

    # Then
    assert_equal nil, @redis.get( @key )
    assert_equal [], @redis.smembers( @key )
    assert_equal [], @redis.zrange( @key, 0, -1 )
    assert_equal Hash.new, @redis.hgetall( @key )
  end

end
