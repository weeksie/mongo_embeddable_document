class ExampleClass
  include MongoMapper::Document
  include MongoMapper::EmbeddableDocument
  
  key :name, String
  key :age, Integer
  key :bio, String
  
  embedded_attributes :name, :age, :karate
  class Embedded
    key :karate, Hash
  end
end
