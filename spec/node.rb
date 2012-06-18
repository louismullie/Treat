require_relative '../lib/treat'

describe Treat::Entities::Node do

  before :each do
    @root = Treat::Entities::Node.new('root node', 'root')
    @branch = Treat::Entities::Node.new('branch node', 'branch')
    @sibling = Treat::Entities::Node.new('sibling node', 'sibling')
    @leaf = Treat::Entities::Node.new('leaf node', 'leaf')
    @root << @branch << @leaf
    @root << @sibling
    
    @leaf.link(@sibling, 'some dependency')
    @leaf.set :some_feature, 'value'
    
  end

  describe "#[]" do
    it "allows traversal of the tree by node ID" do
      @root['branch'].should eql @branch
      @root['branch']['leaf'].should eql @leaf
    end
  end
  
=begin
  describe "#right, #left" do
    it "return the right/left sibling from the same parent node"
    @branch.right.should eql @sibling
    @sibling.left.should eql @branch
  end

  describe "#remove!" do
    it "removes a children by instance or ID and returns it" do
      @root.remove!(@sibling).should eql @sibling
      @root.size.should eql 3
      @root.remove!(@branch.id).should eql @branch
      @root.size.should eql 2
    end
  end
  
  describe "#remove_all!" do
    it "removes all a node's children"
    @branch.remove_all!.size.should eql 0
  end

=end

  describe "#set(feature, value) and #get(feature)" do
    it "set and get a feature in the @features hash" do 
      @root.set :foo, true
      @root.get(:foo).should eql true
    end
  end
  
  describe "#size" do
    it "returns the total number of nodes in the tree" do
      @root.size.should eql 4
    end
  end

  describe "#id" do
    it "returns the unique ID of the node" do
      @root.id.should eql 'root'
      @branch.id.should eql 'branch'
      @leaf.id.should eql 'leaf'
    end
  end

  describe "#value" do
    it "contains the string value of the node" do
      @root.value.should eql 'root node'
      @branch.value.should eql 'branch node'
      @leaf.value.should eql 'leaf node'
    end
  end

  describe "#has_children?" do
    it "tells whether the node has children or not" do
      @root.has_children?.should eql true
      @branch.has_children?.should eql true
      @leaf.has_children?.should eql false
    end
  end
  
  describe "#has_parent?" do
    it "tells whether the node has a parent or not" do
      @root.has_parent?.should eql false
      @branch.has_parent?.should eql true
      @leaf.has_parent?.should eql true
    end
  end

  describe "#has_children?" do
    it "tells whether the node has children or not" do
      @root.has_children?.should eql true
      @branch.has_children?.should eql true
      @leaf.has_children?.should eql false
    end
  end

  describe "#has_features?" do
    it "tells whether the node has children or not" do
      @root.has_features?.should eql false
      @branch.has_features?.should eql false
      @leaf.has_features?.should eql true
    end
  end

  describe "#has_dependencies?" do
    it "tells whether the node has dependencies or not" do
      @root.has_dependencies?.should eql false
      @branch.has_dependencies?.should eql false
      @leaf.has_dependencies?.should eql true
    end
  end

end
