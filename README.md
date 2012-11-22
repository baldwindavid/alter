# Alter

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/baldwindavid/alter)

Passing something like a blog post through many complex filters (Markdown, Liquid, regex, Nokogiri, etc) can get ugly and difficult to test and debug. Alter enforces structure and consistency by moving each filter to easy-to-write processor classes. It also keeps a handy history of all "alterations". The source is a mere 50 lines of code, so it should be easy to read and extend.

## Installation

Add this line to your application's Gemfile:

    gem 'alter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alter

## Usage

Suppose you are building a blog and you want to run posts through a number of filters when converting to HTML. You might run it through Liquid, then Markdown, then do some crazy Nokogiri stuff, then rewrite YouTube URLs to embedded videos, then sanitize, do some regex replaces, etc. And maybe you want to run it through only some filters in one area of the site, but all filters in other areas. This can quickly get ugly and disorganized.

Alter gives you structure and consistency by passing text (or really anything) through easy to write processor classes. All you need to do is inherit from `Alter::Processor` and provide an `output` method.

<pre lang="ruby"><code>
class KumbayaProcessor &#60; Alter::Processor
  def output
    input.gsub("sucks", "is great")
  end
end
</code></pre>
    
You will already have access to the `input` attribute. You are simply delivering the `output` based upon the `input`. To use the processor, you will first create a new Alter item which will setup that initial `input` value.

<pre lang="ruby"><code>
text = Alter::Item.new "Your language sucks"
</code></pre>
    
Now you can run that item through the processor by passing the `KumbayaProcessor` class to the process method. The process method also accepts an array of processors.

<pre lang="ruby"><code>
text.process KumbayaProcessor
text.value
# result: "Your language is great"
</code></pre>

Calling process returns the altered item. Items have the following attributes:

- `value` - the current value of the item
- `input` - the original input of the item
- `options` - the original options passed to the item
- `history` - a history of every item alteration
    
You will also have access to any `options` passed to the processor. Here is a class making use of `options`.

<pre lang="ruby"><code>
class EligibilityProcessor &#60; Alter::Processor
  def output
    if options[:age] >= 35
      input + " and you could run for President"
    else
      input + " but you're too young to be President"
    end
  end
end

text = Alter::Item.new "Your language sucks", :age => 37
text.process [KumbayaProcessor, EligibilityProcessor]
text.value
# result: "Your language is great and you could run for President"
</code></pre>
    
You can just as easily chain or separate these process calls. Options can also be passed to the process method if you only want them available to specific processors.

<pre lang="ruby"><code>
text = Alter::Item.new "Your language sucks"
text.process KumbayaProcessor
text.process EligibilityProcessor, :age => 33
text.value
# result: "Your language is great but you're too young to be President"
</code></pre>
    
### History

Alter keeps a history of every "alteration" made to the original input and stores it in the `history` array.

<pre lang="ruby"><code>
pp text.history.collect {|h| {:processor => h.processor, :input => h.input, :output => h.output, :options => h.options, :meta => h.meta}}
</code></pre>

<pre lang="console"><code>
result:  
[{:processor=>KumbayaProcessor,
  :input=>"Your language sucks",
  :output=>"Your language is great",
  :options=>{},
  :meta=>nil},
 {:processor=>EligibilityProcessor,
  :input=>"Your language is great",
  :output=>"Your language is great but you're too young to be President",
  :options=>{:age=>33},
  :meta=>nil}]
</code></pre>
        
### Metadata

Extra metadata can be written to the history by providing a `meta` method in the processor class.

<pre lang="ruby"><code>
class UselessProcessor &#60; Alter::Processor
  def meta
    { 
      :random => "This is so #{rand(1000)}",
      :data => "This is so meta"
    }
  end
end
</code></pre>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
