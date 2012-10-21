# Defines a classification problem.
# - What question are we trying to answer?
# - What features are we going to look at
#   to attempt to answer that question?
class Treat::Learning::Problem

  # A unique identifier for the problem.
  attr_accessor :id
  # The question we are trying to answer.
  attr_reader :question
  # An array of features that will be 
  # looked at in trying to answer the
  # problem's question.
  attr_reader :features
  attr_reader :tags
  # Just the labels from the features.
  attr_reader :feature_labels
  attr_reader :tag_labels
  
  # Initialize the problem with a question
  # and an arbitrary number of features.        # FIXME: init with id!?
  def initialize(question, *exports)
    unless question.is_a?(Treat::Learning::Question)
      raise Treat::Exception,
      "The first argument to initialize " +
      "should be an instance of " +
      "Treat::Learning::Question."
    end
    if exports.any? { |f| !f.is_a?(Treat::Learning::Export) }
      raise Treat::Exception,
      "The second argument and all subsequent ones " +
      "to initialize should be instances of subclasses " +
      "of Treat::Learning::Export."
    end
    @question, @id = question, object_id
    @features = exports.select do |exp|
      exp.is_a?(Treat::Learning::Feature)
    end
    if @features.size == 0
      raise Treat::Exception, 
      "Problem should be supplied with at least "+
      "one feature to work with."
    end
    @tags = exports.select do |exp|
      exp.is_a?(Treat::Learning::Tag)
    end
    @feature_labels = @features.map { |f| f.name }
    @tag_labels = @tags.map { |t| t.name }
  end
  
  # Custom comparison for problems.
  # Should we check for ID here ? FIXME
  def ==(problem)
    @question == problem.question &&
    @features == problem.features &&
    @tags == problem.tags
  end

  # Return an array of all the entity's
  # features, as defined by the problem.
  # If include_answer is set to true, will
  # append the answer to the problem after
  # all of the features.
  def export_features(e, include_answer = true)
    features = export(e, @features)
    return features unless include_answer
    features << (e.has?(@question.name) ? 
    e.get(@question.name) : @question.default)
    features
  end
  
  def export_tags(entity)
    if @tags.empty?
      raise Treat::Exception,
      "Cannot export the tags, because " +
      "this problem doesn't have any."
    end
    export(entity, @tags)
  end

  def export(entity, exports)
    unless @question.target == entity.type
      raise Treat::Exception, 
      "This classification problem targets #{@question.target}s, " +
      "but a(n) #{entity.type} was passed to export instead."
    end
    ret = []
    exports.each do |export|
      r = export.proc ? 
      export.proc.call(entity) : 
      entity.send(export.name)
      ret << (r || export.default)
    end
    ret
  end
  
  def to_hash
    {'question' => object_to_hash(@question),
    'features' => @features.map { |f| 
    object_to_hash(f.tap { |f| f.proc = nil }) },
    'tags' => @tags.map { |t| 
    object_to_hash(t.tap { |t| t.proc = nil }) },
    'id' => @id }
  end
  
  def object_to_hash(obj)
    hash = {}
    obj.instance_variables.each do |var|
      val = obj.instance_variable_get(var)
      hash[var.to_s.delete("@")] = val
    end
    hash
  end
  
  def self.from_hash(hash)
    question = Treat::Learning::Question.new(
      hash['question']['name'], 
      hash['question']['target'],
      hash['question']['type'],
      hash['question']['default'],
      hash['question']['labels']
    )
    features = []
    hash['features'].each do |feature|
      features << Treat::Learning::Feature.new(
      feature['name'], feature['default'],
      feature['proc_string'])
    end
    tags = []
    hash['tags'].each do |tag|
      tags << Treat::Learning::Tag.new(
      tag['name'], tag['default'],
      tag['proc_string'])
    end
    features_and_tags = features + tags
    p = Treat::Learning::Problem.new(question, *features_and_tags)
    p.id = hash['id']
    p
  end

end