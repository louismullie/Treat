# Sentence segmentation based on a Naive Bayesian
# statistical model. Trained on Wall Street Journal 
# news combined with the Brown Corpus, which is 
# intended to be widely representative of written English.
#
# Original paper: Dan Gillick. 2009. Sentence Boundary 
# Detection and the Problem with the U.S. University 
# of California, Berkeley.
class Treat::Workers::Processors::Segmenters::Tactful
  
  # Require the 'tactful_tokenizer' gem.
  silence_warnings { require 'tactful_tokenizer' }
  
  # Remove function definition 'tactful_tokenizer' by gem.
  String.class_eval { undef :tokenize }
  
  # Keep only one copy of the segmenter.
  @@segmenter = nil
  
  # Segment a text or zone into sentences
  # using the 'tactful_tokenizer' gem.
  #
  # Options: none.
  def self.segment(entity, options = {})

    entity.check_hasnt_children
    
    s = entity.to_s
    s.escape_floats!
    
    # Remove abbreviations.
    s.scan(/(?:[A-Za-z]\.){2,}/).each do |abbr| 
      s.gsub!(abbr, abbr.gsub(' ', '').gsub('.', '&-&'))
    end
    
    # Take out suspension points temporarily.
    s.gsub!('...', '&;&.')
    # Unstick sentences from each other.
    s.gsub!(/([^\.\?!]\.|\!|\?)([^\s"'])/) { $1 + ' ' + $2 }
    
    @@segmenter ||= TactfulTokenizer::Model.new
   
    sentences = @@segmenter.tokenize_text(s)
    
    sentences.each do |sentence|
      sentence.unescape_floats!
      # Repair abbreviations.
      sentence.gsub!('&-&', '.')
      # Repair suspension points.
      sentence.gsub!('&;&.', '...')
      entity << Treat::Entities::Phrase.from_string(sentence)
    end
    
  end
  
end