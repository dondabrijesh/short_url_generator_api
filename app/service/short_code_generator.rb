class ShortCodeGenerator
  ALPHABET = (("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a).freeze
  LENGTH = 7

  def self.call
    LENGTH.times.map { ALPHABET.sample }.join
  end
end
