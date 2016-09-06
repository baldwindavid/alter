require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Item" do

  before :each do

    class TextProcessor < Alter::Processor
      def output
        input + " + output"
      end

      def meta
        {
          :color => "blue",
          :rand => rand(1000)
        }
      end
    end

    class FirstProcessor < Alter::Processor
      def output
        input + " + first"
      end
    end

    class SecondProcessor < Alter::Processor
      def output
        input + " + second"
      end
    end

    class EligibilityProcessor < Alter::Processor
      def output
        if options[:age] >= 35
          input + " + President eligible"
        else
          input + " + Too young to be President"
        end
      end
    end

  end

  it "should update the value based upon a custom output method in a processor" do
    @item = Alter::Item.new "Initial text"
    @item.process TextProcessor
    @item.value.should == "Initial text + output"
  end

  it "should allow the value to be called as output" do
    @item = Alter::Item.new "Initial text"
    @item.process TextProcessor
    @item.output.should == "Initial text + output"
  end

  it "should allow an array of processors to be passed via the process method" do
    @item = Alter::Item.new "Initial text"
    @item.process [FirstProcessor, SecondProcessor]
    @item.value.should == "Initial text + first + second"
  end

  it "should allow processors to be chained" do
    @item = Alter::Item.new "Initial text"
    @item.process FirstProcessor
    @item.value.should == "Initial text + first"
    @item.process SecondProcessor
    @item.value.should == "Initial text + first + second"
  end

  it "should write history to the item" do
    @item = Alter::Item.new "Initial text"
    @item.process [FirstProcessor, SecondProcessor]
    @item.history.size.should == 2
  end

  it "should attach meta data to the history if provided" do
    @item = Alter::Item.new "Initial text"
    @item.process TextProcessor
    @item.history.first.meta[:color].should == "blue"
  end

  it "should write a static alteration record to the history" do
    @item = Alter::Item.new "Initial text"
    @item.process TextProcessor
    first_request = @item.history.first.meta[:rand]
    @item.history.first.meta[:rand] == first_request
  end

  it "should allow passing options via the item" do
    @item = Alter::Item.new "Initial text", :age => 36
    @item.process EligibilityProcessor
    @item.value.should == "Initial text + President eligible"
  end

  it "should allow passing options via the process method" do
    @item = Alter::Item.new "Initial text"
    @item.process EligibilityProcessor, :age => 32
    @item.value.should == "Initial text + Too young to be President"
  end

end
