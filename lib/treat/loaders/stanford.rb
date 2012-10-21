# A helper class to load the CoreNLP package.
class Treat::Loaders::Stanford
  
  # Keep track of whether its loaded or not.
  @@loaded = false

  # Load CoreNLP package for a given language.
  def self.load(language = nil)
    return if @@loaded
    require 'stanford-core-nlp'
    language ||= Treat.core.language.default
    StanfordCoreNLP.jar_path = 
    Treat.libraries.stanford.jar_path || 
    Treat.paths.bin + 'stanford/'
    StanfordCoreNLP.model_path = 
    Treat.libraries.stanford.model_path || 
    Treat.paths.models + 'stanford/'
    StanfordCoreNLP.use(language)
    StanfordCoreNLP.log_file = '/dev/null' if 
    Treat.core.verbosity.silence
    StanfordCoreNLP.bind; @@loaded = true
  end
  
end
