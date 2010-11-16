require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'mongo_mapper'
require 'embeddable_document'

class TestEmbeddableDocument < Test::Unit::TestCase
  include Shoulda
  
  class ::Fnord
    include MongoMapper::Document
    include MongoMapper::EmbeddableDocument
    
    key :fliff
    key :radness
    
    embedded_attributes :fliff
  end
  
  context "a MongoMapper::Document that HasEmbedded" do
    
    should "create an embedded class" do
      embedded = Fnord::Embedded.new
     
      assert Fnord::Embedded.include?(MongoMapper::EmbeddedDocument)
      assert embedded.respond_to?(:fliff)
      assert !embedded.respond_to?(:radness)
    end
    
    should "return an embedded version of the base class" do
      f  = Fnord.new :fliff => "SULTAN"
      ef = f.as_embedded
      
      assert_equal f.id, ef.original_id
      assert_equal f.fliff, ef.fliff
    end
    
    should "call find on parent document with original id" do
      f  = Fnord.new :fliff => "sultan"
      ef = f.as_embedded
      
      Fnord.expects(:find).with f.id
      ef.original_document
    end
    
  end
end
