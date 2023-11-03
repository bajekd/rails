class ShortCode
  ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
  BASE = ALPHABET.length

  def self.encode(id)
    raise TypeError unless id.is_a?(Numeric)
    return '0' if id.zero? || id.nil?

    result = ''
    while id.positive?
      index = id % BASE
      char = ALPHABET[index]
      result.prepend(char)
      id /= BASE
    end

    result
  end

  def self.decode(code)
    raise TypeError unless code.is_a?(String)

    number = 0
    code.reverse.each_char.with_index do |char, exp|
      power = BASE**exp
      index = ALPHABET.index(char)
      number += index * power
    end

    number
  end
end
