require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'mongo_mapper'
require 'mongo_mapper_embeddable_document'
require 'example_class'


class TestEmbeddableDocument < Test::Unit::TestCase
  include Shoulda
  
  class ::Fnord
    include MongoMapper::Document
    include MongoMapper::EmbeddableDocument
    
    key :fliff
    key :radness
    
    key :pickle, Integer, :required => true
    
    embedded_attributes :fliff, :pickle, :cheese, :flimflam
    
    # attribute on embedded class that doesn't exist on the parent.
    class Embedded
      key :flimflam
    end
    
    
    def cheese
      "FNORD!"
    end
  end
  
  context "a MongoMapper::Document that is an EmbeddableDocument" do
    
    should "create an embedded class" do
      embedded = Fnord::Embedded.new
     
      assert Fnord::Embedded.include?(MongoMapper::EmbeddedDocument)
      assert embedded.respond_to?(:fliff)
      assert !embedded.respond_to?(:radness)
    end
    
    should "return an embedded version of the base class" do
      f  = Fnord.new :fliff => "SULTAN", :pickle => 1
      ef = f.as_embedded

      assert_equal f.id, ef.original_id
      assert_equal f.fliff, ef.fliff
      assert_equal f.pickle, ef.pickle
      assert_equal f.cheese, ef.cheese
      assert ef.respond_to?(:flimflam)
      assert !f.respond_to?(:flimflam)
    end
    
    should "return the embedded class of the base class" do
      assert_equal Fnord::Embedded, Fnord.embedded_class
    end
    
    should "call find on parent document with original id" do
      f  = Fnord.new :fliff => "sultan"
      ef = f.as_embedded
      Fnord.expects(:find).with f.id
      ef.original_document
    end
    
    should "handle embedded attributes that aren't present on the parent class" do
      assert_nothing_raised do
        f  = ExampleClass.new :name => "Ed"
        ef = f.as_embedded
        ef.karate = { :karate => "flimflam" }
      end
    end
    
  end
end
