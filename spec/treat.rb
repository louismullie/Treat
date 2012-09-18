require_relative 'helper'

describe Treat do

  describe "Syntactic sugar:" # Move to config?

  describe "#sweeten!, #unsweeten!" do

    it "respectively turn on and off syntactic sugar and " +
    "define/undefine entity builders as uppercase methods " +
    "in the global namespace" do

      Treat.core.entities.list.each do |type|

        next if type == :symbol

        Treat::Config.sweeten!

        Treat.core.syntax.sweetened.should eql true

        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql true

        Treat::Config.unsweeten!
        Treat.core.syntax.sweetened.should eql false

        Object.method_defined?(
        type.to_s.capitalize.intern).should eql false

        Object.method_defined?(
        :"#{type.to_s.capitalize}").
        should eql false
        
      end

    end

  end

  describe "Paths:" do

    paths = Treat.core.paths.description
    # Check IO for bin, files, tmp, models. Fix.
    paths.each_pair do |path, files|
      describe "##{path}" do
        it "provides the path to the #{files}" do
          Treat.paths[path].should be_instance_of String
        end
      end
    end

  end

end