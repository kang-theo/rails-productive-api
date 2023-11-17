module Productive
  module HttpClient
    @@endpoint = ProductiveConf.endpoint
    @@headers = ProductiveConf.auth_info

    def self.get(req_params)
      Rails.logger.info("HTTP Request: #{@@endpoint}/#{req_params}")
      HTTParty.get("#{@@endpoint}/#{req_params}", headers: @@headers)
    end

    # def post(uri, data)
    #   @options[:body] = data.to_json
    #   self.class.post(uri, @options)
    # end

    # def put(uri, data)
    #   @options[:body] = data.to_json
    #   self.class.put(uri, @options)
    # end

    # def delete(uri)
    #   self.class.delete(uri, @options)
    # end
  end
end
