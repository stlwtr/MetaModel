require "metamodel/metafile/dsl"

module MetaModel
  class Metafile
    include MetaModel::Metafile::DSL

    attr_accessor :defined_in_file
    attr_accessor :current_model

    attr_accessor :models
    attr_accessor :associations

    def initialize(defined_in_file = nil, internal_hash = {})
      @defined_in_file = defined_in_file
      @models = []
      @associations = []

      evaluate_model_definition(defined_in_file)
      amend_association
    end

    def evaluate_model_definition(path)
      contents ||= File.open(path, 'r:utf-8', &:read)

      if contents.respond_to?(:encoding) && contents.encoding.name != 'UTF-8'
        contents.encode!('UTF-8')
      end

      eval(contents, nil, path.to_s)

    end

    def self.from_file(path)
      path = Pathname.new(path)
      unless path.exist?
        raise Informative, "No Metafile exists at path `#{path}`."
      end

      case path.extname
      when '', '.metafile'
        Metafile.new(path)
      else
        raise Informative, "Unsupported Metafile format `#{path}`."
      end
    end

    # def models
    #   get_hash_value('models', [])
    # end
    #
    # def associations
    #   get_hash_value('associations', [])
    # end
    #
    # HASH_KEYS = %w(
    #   models
    #   associations
    # ).freeze
    #
    # def set_hash_value(key, value)
    #   unless HASH_KEYS.include?(key)
    #     raise Informative, "Unsupported hash key `#{key}`"
    #   end
    #   internal_hash[key] = value
    # end
    #
    # def get_hash_value(key, default = nil)
    #   unless HASH_KEYS.include?(key)
    #     raise Informative, "Unsupported hash key `#{key}`"
    #   end
    #   internal_hash.fetch(key, default)
    # end

    def amend_association
      name_model_hash = Hash[@models.collect { |model| [model.name, model] }]
      @associations.map! do |association|
        major_model = name_model_hash[association.major_model]
        major_model.associations << association
        association.major_model = major_model
        association.secondary_model = name_model_hash[association.secondary_model]
        raise Informative, "Associations not satisfied in `Metafile`" unless [association.major_model, association.secondary_model].compact.size == 2
        association
      end
      self
    end
  end
end
