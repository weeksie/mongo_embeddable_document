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
        args.each do |attr|
          if keys[attr.to_s]
            options = keys[attr.to_s].options.reject{ |k,_| k.to_s =~ /index/ }
            embedded_class.send :key, attr, keys[attr.to_s].type, options
          else
            embedded_class.send :key, attr
          end
        end
        embedded_class.send :key, :original_id, ObjectId
      end
      

      def define_embedded_class
        base_class = self
        embedded   = const_set "Embedded", Class.new
        embedded.send :include, MongoMapper::EmbeddedDocument
        
        embedded.class_eval do 
          define_method :parent_class do
            base_class
          end
          
          define_method :original_document do |*args|
            base_class.find original_id
          end
        end  
      end

      def embedded_class
        @embedded_class ||= "::#{self.name}::Embedded".constantize
      end
    end
    
    module InstanceMethods
      
      # returns an embedded version of the main document
      def as_embedded
        embedded_object = self.class.embedded_class.new
        self.class.embedded_class.keys.reject{ |k,_| k =~ /^_id|original_id$/ }.each do |key, value|
          embedded_object.send "#{key}=", self.send(key.to_sym) if self.respond_to?(key.to_sym)
        end
        embedded_object.original_id = id
        embedded_object
      end
    end
    
  end
end
