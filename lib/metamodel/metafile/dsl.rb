module MetaModel
  class Metafile
    module DSL
      require 'metamodel/record/model'
      require 'metamodel/record/property'
      require 'metamodel/record/association'

      def metamodel_version(version)
        raise Informative,
          "Meta file #{version} not matched with current metamodel version #{VERSION}" if version != VERSION
      end

      def define(model_name)
        UI.message '-> '.green + "Resolving `#{model_name.to_s.camelize}`"
        @current_model = Record::Model.new(model_name)
        yield if block_given?
        @models << @current_model
      end

      def attr(key, type = :string, **args)
        @current_model.properties << Record::Property.new(key, type, args)
      end

      def has_one(name, model_name = nil, **args)
        model_name = name.to_s.singularize.camelize if model_name.nil?
        association = Record::Association.new(name, current_model.name, model_name, :has_one, args)
        @associations << association
      end

      def has_many(name, model_name = nil, **args)
        model_name = name.to_s.singularize.camelize if model_name.nil?
        raise Informative, "has_many relation can't be created with optional model name" if model_name.end_with? "?"
        association = Record::Association.new(name, current_model.name, model_name, :has_many, args)
        @associations << association
      end

      def belongs_to(name, model_name = nil, **args)
        model_name = name.to_s.singularize.camelize if model_name.nil?
        association = Record::Association.new(name, current_model.name, model_name, :belongs_to, args)
        @associations << association
      end
    end
  end
end
