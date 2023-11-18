module Productive
  module HttpClient
    @@endpoint = ProductiveConf.endpoint
    @@headers = ProductiveConf.auth_info

    def self.get(req_params)
      Rails.logger.info("HTTP Request: #{@@endpoint}/#{req_params}")
      HTTParty.get("#{@@endpoint}/#{req_params}", headers: @@headers)
    end

    def post(req_params, data)
      @options[:body] = data.to_json
      HTTParty.post(uri, @options)
    end

    def put(req_params, data)
      @options[:body] = data.to_json
      HTTParty.put(uri, @options)
    end

    def delete(req_params)
      HTTParty.delete(uri, @options)
    end
  end
end