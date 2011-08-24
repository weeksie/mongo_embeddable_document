module MongoMapper
  module EmbeddableDocument
    
    def self.included(base)
      base.extend ClassMethods
      base.send :include, InstanceMethods
      base.define_embedded_class
    end
    
    module ClassMethods
      
      # takes a list of symbols that define the keys that should be
      # passed to the embedded document.
      def embedded_attributes(*args)
        embedded_class = "::#{self.name}::Embedded".constantize
        args.each do |attr|
          if keys[attr]
            embedded_class.send :key, attr, keys[attr].type, keys[attr].options
          else
            embedded_class.send :key, attr
          end
        end
        embedded_class.send :key, :original_id, ObjectId
      end
      

      def define_embedded_class
        base_class     = self
        embedded_class = const_set "Embedded", Class.new
        embedded_class.send :include, MongoMapper::EmbeddedDocument
        
        embedded_class.class_eval do 
          define_method :parent_class do
            base_class
          end
          
          define_method :original_document do |*args|
            base_class.find original_id
          end
        end  
      end
      
      def embedded_class
        "::#{self.name}::Embedded".constantize
      end
    end
    
    module InstanceMethods
      
      # returns an embedded version of the main document
      def as_embedded
        embedded_class  = "::#{self.class.name}::Embedded".constantize
        embedded_object = embedded_class.new
        embedded_class.keys.reject{ |k,_| k =~ /_id|original_id/ }.each do |key, value|
          embedded_object.send "#{key}=", self.send(key.to_sym) if self.respond_to?(key.to_sym)
        end
        embedded_object.original_id = id
        embedded_object
      end
    end
    
    
  end
end
