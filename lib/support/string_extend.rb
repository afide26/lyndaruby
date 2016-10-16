# This helper is opening up core Ruby String class
# in order to add a new method to all strings

class String
  # Ruby has a capitalize method (used in this method) which capitalizes
  # the first letter of a string. We want to capitalize the first letter
  # of each word in a string by writing our OWN Method

  def titleize
    self.split(' '). collect {|word| word.capitalize}.join(" ")
  end
end