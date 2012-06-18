# This class is a wrapper for the functions included
# in the 'linguistics' gem that allow to describe a
# number in words in cardinal form.
#
# Project website: http://deveiate.org/projects/Linguistics/
module Treat::Workers::Inflectors::Cardinalizers::Linguistics
  
  require 'treat/loaders/linguistics'
  
  DefaultOptions = {
    :language => Treat.core.language.default
  }
  
  # Return the description of a cardinal number in words.
  #
  # Options:
  #
  # - :group => Controls how many numbers at a time are
  # grouped together. Valid values are 0 (normal grouping),
  # 1 (single-digit grouping, e.g., “one, two, three, four”),
  # 2 (double-digit grouping, e.g., “twelve, thirty-four”, or
  # 3 (triple-digit grouping, e.g., “one twenty-three, four”).
  # - :comma => Set the character/s used to separate word groups.
  # Defaults to ", ".
  # - :and => Set the word and/or characters used where ' and '
  # (the default) is normally used. Setting :and to ' ', for
  # example, will cause 2556 to be returned as “two-thousand,
  # five hundred fifty-six” instead of “two-thousand, five
  # hundred and fifty-six”.
  # - :zero => Set the word used to represent the numeral 0 in
  # the result. 'zero' is the default.
  # - :decimal => Set the translation of any decimal points in
  # the number; the default is 'point'.
  # - :asArray If set to a true value, the number will be returned
  # as an array of word groups instead of a String.
  #
  # More specific options when using :type => :ordinal:
  def self.cardinal(entity, options = {})
    options = DefaultOptions.merge(options)
    Treat::Loaders::Linguistics.
    load(options[:language]).
    numwords(entity.to_s, options)
  end
  
end