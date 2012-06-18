# Currently, this MLP is limited to 1 output.
class Treat::Workers::Learners::Classifiers::MLP
  
  require 'ai4r'
  
  @@mlps = {}
  
  def self.classify(entity, options = {})
    
    set = options[:training]
    cl = set.classification
      
    if !@@mlps[cl]
      net = Ai4r::NeuralNetwork::
      Backpropagation.new([cl.labels.size, 3, 1])
      set.items.each do |item|
        inputs = item[0..-2]
        outputs = [item[-1]]
        net.train(inputs, outputs)
      end
      @@mlps[cl] = net
    else
      net = @@mlps[cl]
    end
    
    net.eval(cl.export_item(entity, false))[0]
    
  end
  
end