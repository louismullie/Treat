describe Treat::Core::Question do

  describe "#initialize" do
    context "when supplied with acceptable parameters" do
      it "should give access to the parameters" do
        question = Treat::Core::Question.new(
        :is_keyword, :word, :continuous, 0, [0, 1])
        question.name.should eql :is_keyword
        question.target.should eql :word
        question.type.should eql :continuous
        question.default.should eql 0
        question.labels.should eql [0, 1]
      end
    end
    context "when supplied with wrong parameters" do
      it "should raise an exception" do
        # Name should be a symbol
        expect { Treat::Core::Question.new(
        nil, :sentence) }.to raise_error
        # Target should be an actual entity type
        expect { Treat::Core::Question.new(
        :name, :foo) }.to raise_error
        # Distribution type should be continuous or discrete
        expect { Treat::Core::Question.new(
        :name, :sentence, :nonsense) }.to raise_error
      end
    end
  end

  describe "#==(question)" do
    context "when supplied with an equal question" do
      it "should return true" do
        Treat::Core::Question.new(
        :is_keyword, :word).
        should == Treat::Core::Question.new(
        :is_keyword, :word)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous).
        should == Treat::Core::Question.new(
        :is_keyword, :word, :continuous)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should == Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1])
      end
    end
    context "when supplied with a different question" do
      it "should return false" do
        Treat::Core::Question.new(
        :is_keyword, :word).
        should_not == Treat::Core::Question.new(
        :is_keyword, :sentence)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous).
        should_not == Treat::Core::Question.new(
        :is_keyword, :word, :discrete)
        Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [0, 1]).
        should_not == Treat::Core::Question.new(
        :is_keyword, :word, :continuous, [1, 0])
      end
    end
  end

end