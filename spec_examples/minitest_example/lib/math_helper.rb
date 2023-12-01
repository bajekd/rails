module MathHelper
  def self.percentage(numerator, denominator)
    return 0.0 if denominator.zero?

    (numerator.to_f / denominator * 100.0).round(2)
  end
end
