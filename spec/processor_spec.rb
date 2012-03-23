require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Processor" do
  
  before :each do
    
    class TextProcessor < Alter::Processor
      def output
        input + " + output"
      end
    end
    
    class UselessProcessor < Alter::Processor
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
  
  it "should produce an output based upon a custom output method" do
    @processor = TextProcessor.new "Initial text" 
    @processor.output.should == "Initial text + output"
  end 

  it "should have an output equal to its input if no custom output method is provided" do
    @processor = UselessProcessor.new "Initial text"
    @processor.output.should == "Initial text"
  end
  
  it "should allow changing output based upon options" do
    @processor = EligibilityProcessor.new "Initial text", :age => 42
    @processor.output.should == "Initial text + President eligible"
  end

  
end