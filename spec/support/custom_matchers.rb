module YogaSite
  module CustomMatchers
    # Matcher for JSON.
    #
    # Borrowed from http://www.mail-archive.com/rspec-users@rubyforge.org/msg11319.html
    #
    # == Usage
    #
    #   some_json.should be_json {'name' => 'James'}
    #   # or
    #   some_json.should be_json @object.to_json
    #
    def be_json(json)
      BeJSON.new(json)
    end

    # Matcher for JSON responses.
    #
    # == Usage
    #
    #   response.should render_json assigns(:foo).to_json
    #   # or
    #   response.should render_json {'name' => 'James'}
    #
    # == Validation
    #
    # To match, a response must pass two tests:
    # 
    #   1. Response content_type should be 'application/json'
    #   2. Response body should be equal to the given JSON
    #
    def render_json(json)
      RenderJSON.new(json)
    end
    
    # Matcher for new database models.
    #
    # == Usage
    #
    #   assigns(:person).should be_new_person
    #
    # == Validation
    #
    # To pass, an object must:
    #
    #   1. Be of the correct class (using object.class == class)
    #   2. Be a new_record?
    #
    # TODO:2: method_missing for be_new_{model} doesn't work.
    def method_missing(method, *args, &block)
      if method =~ /^be_new_a(.+)$/
        BeNewModel.new($1)
      else
        super
      end
    end
    
    # Matcher class for be_json method.
    class BeJSON
      def initialize(expected)
        @expected = Utils.decode_json(:expected, expected)        
      end
      
      def matches?(json)
        @actual = Utils.decode_json(:actual, json)
        @actual == @json
      end
      
      def failure_message
        <<-EOS
expected: #{@expected.inspect} 
     got: #{@actual.inspect}
EOS
      end
      
      def negative_failure_message
        "expected #{@actual.inspect} to be different from #{@expected.inspect}"
      end
    end
    
    # Matcher class for render_json method
    class RenderJSON
      def initialize(json)
        @json = Utils.decode_json(:expected, json)
      end
    
      def matches?(response)
        @content_type = response.content_type
        @body         = Utils.decode_json(:actual, response.body)
      
        content_type_match? && json_match?
      end
      
      def content_type_match?
        @content_type == 'application/json'
      end
      
      def json_match?
        @body == @json        
      end
    
      def failure_message
        <<-EOS
  expected: content_type text/javascript, body #{@json.inspect}
       got: content_type #{@content_type}, body #{@body.inspect}
EOS
      end
    
      def negative_failure_message
        <<-EOS
  expected: content_type not text/javascript or body not #{@json.inspect}
       got: content_type #{@content_type} and body #{@body.inspect}
  EOS
      end
    end
    
    # Matcher class for be_new_{model_name}
    class BeNewModel
      def initialize(model)
        @model = model.classify.constantize
      end
      
      def matches?(object)
        (@object = object).class.should == @model && @object.new_record?
      end

      def failure_message
        <<-EOS
expected: #{@model.class.inspect} and new_record? == true
     got: #{@model.class.inspect} and new_record? == #{@object.new_record?}
EOS
      end
    end
    
    module Utils
      extend self

      def decode_json(origin, json)
        ActiveSupport::JSON.decode(json) || json
      rescue
        raise ArgumentError, "Invalid #{origin} JSON: #{json.inspect}"
      end          
    end
  end
end
