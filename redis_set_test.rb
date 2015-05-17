require File.expand_path( "../test_helper.rb", __FILE__ )

class RedisSetTest < RedisTestCase
  
  def test_is_member
    # Given # When
    @redis.sadd( @key, @val )

    # Then 
    assert @redis.sismember( @key, @val )
    refute @redis.sismember( @key, @val1 )
  end

  def test_order_of_sets_cannot_be_predicted
    # Given
    vals = [ @val1, @val2, @val3 ]

    # When
    @redis.sadd( @key, vals )

    # Then
    # both contain same values
    assert_equal_members vals, @redis.smembers( @key )

    # the return value is the same on this run
    assert_equal @redis.smembers( @key ), @redis.smembers( @key )

    # more often than not! (this fails approx 1 in 15 times)
    #refute_equal vals, @redis.smembers( @key )
  end

  def test_cardinality
    # In set theory, cardinality refers to the number of basic members in a set.
    # Given
    vals = [ @val1, @val2, @val3 ]

    # When
    @redis.sadd( @key, vals )

    # Then 
    assert_equal 3, @redis.scard( @key )
  end

  def test_intersection
    # Given
    vals1 = [ @val1, @val2, @val3 ]
    vals2 = [ @val2, @val3, @val4 ]

    # When
    @redis.sadd( @key1, vals1 )
    @redis.sadd( @key2, vals2 )

    # Then 
    assert_equal_members [ @val2, @val3 ], @redis.sinter( @key1, @key2 )
  end

  def test_no_intersection
    # Given
    vals1 = [ @val1, @val2 ]
    vals2 = [ @val3, @val4 ]

    # When
    @redis.sadd( @key1, vals1 )
    @redis.sadd( @key2, vals2 )

    # Then 
    assert_equal_members [], @redis.sinter( @key1, @key2 )
  end

  def test_multiple_intersection
    # Given
    vals1 = [ @val1, @val2, @val3, @val4 ]
    vals2 = [ @val1, @val2, @val4 ]
    vals3 = [ @val1, @val3, @val4 ]

    # When
    @redis.sadd( @key1, vals1 )
    @redis.sadd( @key2, vals2 )
    @redis.sadd( @key3, vals3 )

    # Then 
    assert_equal_members [ @val1, @val4 ], @redis.sinter( @key1, @key2, @key3 )
  end

  def test_interstore
    # Given
    vals1 = [ @val1, @val2, @val3 ]
    vals2 = [ @val2, @val3, @val4 ]

    @redis.sadd( @key1, vals1 )
    @redis.sadd( @key2, vals2 )

    refute @redis.exists( @key3 )

    # When
    @redis.sinterstore( @key3, @key1, @key2 )

    # Then
    assert_equal_members [ @val2, @val3 ], @redis.smembers( @key3 )
  end
end
