require File.expand_path( "../test_helper.rb", __FILE__ )

require "timecop"

class RedisStringTest < TestCase
  # These tests are just me experimenting with the various
  # features of Redis.

  def setup
    # this simply creates a redis client, NOT a server
    @redis = Redis.new

    @key = given_a_random_string
    @val = given_a_random_string
  end

  #-------------------------
  # testing String data type
  #-------------------------

  def test_get_set_key
    # When
    @redis.set @key, @val

    # Then
    assert_equal @val, @redis.get( @key )

    # teardown
    @redis.expire( @key, 0 )
  end

  def test_expire_key
    # Given
    @redis.set @key, nil
    assert @redis.exists( @key )

    # When
    @redis.expire( @key, 0 )

    # Then
    assert !@redis.exists( @key )
  end

  def test_expire_key_in_time
    # Given
    secs = 1

    @redis.set @key, nil, ex: secs
    assert @redis.exists( @key )

    # When
    sleep secs + 0.1

    # Then
    # this only works because less than half a second has passed
    assert !@redis.exists( @key )
  end

  def test_ttl
    # Given
    ttl = 1

    # When
    @redis.set @key, nil, ex: ttl

    # Then
    assert_equal ttl, @redis.ttl( @key )
  end

  def test_ttl
    # Given
    ttl_ms = 100

    # When
    @redis.set @key, nil, px: ttl_ms

    # Then
    # more than half a millisecond may have passed
    assert_in_delta( ttl_ms, @redis.pttl( @key ), 1 )
  end

  def test_persist
    # Given
    ttl = 1

    @redis.set @key, nil, ex: ttl
    assert_equal ttl, @redis.ttl( @key )

    # When
    @redis.persist( @key )

    # Then
    assert_equal -1, @redis.ttl( @key )
    assert @redis.exists( @key )
  end

  # You cannot use Timecop to test Redis expiry because Timecop
  # only affects Ruby, not the Redis server.
  #def test_ttl_with_timecop
  #  # Given
  #  ttl = 100

  #  @redis.set @key, nil, ex: ttl
  #  assert_equal ttl, @redis.ttl( @key )

  #  # When # Then
  #  Timecop.freeze( Time.now + ttl + 1 ) do
  #    refute @redis.exists( @key )
  #  end
  #end

  # Just for kicks
  def test_timecop
    # Given
    past = Time.now - 1000
    refute_equal Time.now, past

    # When
    Timecop.freeze( past ) do

      # Then
      assert_equal Time.now, past

    end

    # teardown
    refute_equal Time.now, past
  end

end
