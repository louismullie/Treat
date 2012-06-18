# Wrapper for the Stanford POS tagger.
class Treat::Workers::Lexicalizers::Taggers::Stanford

  require 'treat/loaders/stanford'

  # Hold one tagger per language.
  @@taggers = {}

  # Hold the default options.
  DefaultOptions =  {
    :tagger_model => nil
  }

  # Tag the word using one of the Stanford taggers.
  def self.tag(entity, options = {})

    # Handle options and initialize the tagger.
    lang = entity.language
    options = get_options(options, lang)
    init_tagger(lang)
    tokens, list = get_token_list(entity)

    # Do the tagging.
    i = 0
    isolated_token = entity.is_a?(Treat::Entities::Token)
    puts @@taggers[lang].inspect
    @@taggers[lang].apply(list).each do |tok|
      tokens[i].set :tag, tok.tag
      tokens[i].set :tag_set,
      options[:tag_set] if isolated_token
      return tok.tag if isolated_token
      i += 1
    end

    # Handle tags for sentences and phrases.
    if entity.is_a?(Treat::Entities::Sentence) ||
      (entity.is_a?(Treat::Entities::Phrase) &&
      !entity.parent_sentence)

      tag_set = options[:tag_set]
      entity.set :tag_set, tag_set
    end

    if entity.is_a?(Treat::Entities::Sentence)
      return 'S'
    elsif entity.is_a?(Treat::Entities::Phrase)
      return 'P'
    end

  end

  # Initialize the tagger for a language.
  def self.init_tagger(language)
    Treat::Loaders::Stanford.load(language)
    model = StanfordCoreNLP::Config::Models[:pos][language] # fix
    model = Treat.paths.models + 'stanford/' +
    StanfordCoreNLP::Config::ModelFolders[:pos] + model
    @@taggers[language] ||=
    StanfordCoreNLP::MaxentTagger.new(model)
  end

  # Handle the options for the tagger.
  def self.get_options(options, language)
    options = DefaultOptions.merge(options)
    if options[:tagger_model]
      ::StanfordCoreNLP.set_model('pos.model',
      options[:tagger_model])
    end
    options[:tag_set] =
    StanfordCoreNLP::Config::TagSets[language]
    options
  end

  # Retrieve a Java ArrayList object.
  def self.get_token_list(entity)
    list = StanfordCoreNLP::ArrayList.new
    if entity.is_a?(Treat::Entities::Token)
      tokens = [entity]
    else
      tokens = entity.tokens
    end
    tokens.each do |token|
      list.add(StanfordCoreNLP::Word.new(token.to_s))
    end
    return tokens, list
  end

end
