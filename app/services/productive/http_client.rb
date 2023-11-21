module Productive
  module HttpClient
    @@endpoint = PRODUCTIVE_CONF['endpoint']
    @@headers = PRODUCTIVE_CONF['auth_info']

    def self.get(req_params)
      cache_key = "httparty_cache/#{req_params}"

      cached_result = Rails.cache.read(cache_key)

      if cached_result.nil?
        Rails.logger.info("HTTP Request: #{@@endpoint}/#{req_params}")
        response = HTTParty.get("#{@@endpoint}/#{req_params}", headers: @@headers)

        Rails.cache.write(cache_key, response, expires_in: 1.hour) # TODO: think of refresh after post

        return response
      else
        Rails.logger.info("Cached result found for #{cache_key}")
        return cached_result
      end
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