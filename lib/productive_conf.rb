class ProductiveConf
  class << self
    attr_accessor :endpoint, :auth_info, :relationships

    def configure
      yield self if block_given?
    end
  end
end
