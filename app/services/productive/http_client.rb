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

        Rails.cache.write(cache_key, response, expires_in: 1.hour)

        return response
      else
        Rails.logger.info("Cached result found for #{cache_key}")
        return cached_result
      end
    end

    def self.post(req_params, payload)
      response = HTTParty.post("#{@@endpoint}/#{req_params}", body: payload, headers: @@headers)
      debugger

      # delete cache after post
      refresh_cache(req_params)
    end

    def self.patch(req_params, payload)
      response = HTTParty.patch("#{@@endpoint}/#{req_params}", body: payload, headers: @@headers)
      debugger

      # delete cache after patch
      refresh_cache(req_params)
    end

    # def self.put(req_params, payload)
    #   @options[:body] = payload.to_json
    #   HTTParty.put(uri, @options)
    # end

    # def self.delete(req_params)
    #   HTTParty.delete(uri, @options)
    # end

    private

    def self.refresh_cache(req_params)
      cache_key = "httparty_cache/#{req_params}"

      Rails.cache.delete(cache_key)
      Rails.logger.info("Cache refreshed after POST request for #{cache_key}")
    end
  end
end