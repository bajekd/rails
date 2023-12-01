require 'test_helper'

class MathHelperTest < ActiveSupport::TestCase
  include MathHelper

  test 'percentage calculates and rounds' do
    assert_equal 50.0, MathHelper.percentage(5, 10)
    assert_equal 50.0, MathHelper.percentage(-2, -4)
    assert_equal(-60.0, MathHelper.percentage(-3, 5))

    assert_equal 33.33, MathHelper.percentage(1, 3)
  end

  test 'precentage returns 0.0 when numerator or denominator is zero' do
    assert_equal 0.0, MathHelper.percentage(5, 0)
    assert_equal 0.0, MathHelper.percentage(0, 10)
    assert_equal 0.0, MathHelper.percentage(0, 0)
  end
end
