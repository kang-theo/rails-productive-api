class ProductiveEntity
#   attr_accessor :data

  def initialize(data)
    @data = data
    create_accessors
  end

  def create_accessors
    @data.each do |key, value|
      define_singleton_method(key) do
        if value.is_a?(Hash)
          self.class.new(value)
        elsif value.is_a?(Array)
          value.map { |item| item.is_a?(Hash) ? self.class.new(item) : item }
        else
          value
        end
      end
    end
  end
end