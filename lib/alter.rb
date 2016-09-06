require "alter/version"

module Alter

  class Item
    attr_accessor :value, :history, :options
    attr_reader :input

		alias_method :output, :value

    def initialize(input, options = {})
      @input = input
      @value = input
      @options = options
      @history = []
    end

    def process(processors = [], mergeable_options = {})
      merged_options = options.merge(mergeable_options)

      [processors].flatten.each do |processor|
        run_processor(processor.new(value, merged_options))
      end

      self
    end

    def run_processor(processor)
      self.value = processor.output
      self.history << Alter::Alteration.new(:processor => processor.class, :input => processor.input, :output => processor.output, :options => processor.options, :meta => processor.meta)
    end
  end

  class Alteration
    attr_accessor :processor, :input, :output, :options, :meta

    def initialize(attrs = {})
      attrs.each { |k, v| self.send("#{k}=", v) }
    end
  end

  class Processor
    attr_accessor :output, :meta
    attr_reader :input, :options

    def initialize(input, options = {})
      @input = input
      @options = options
    end

    def output
      input
    end
  end

end
