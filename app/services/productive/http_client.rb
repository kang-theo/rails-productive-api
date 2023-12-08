module Productive
  module HttpClient
    # TODO: use base_uri to replace endpoint, reducing the #{@@endpoint} in the code
    @@endpoint = PRODUCTIVE_CONF['endpoint']
    @@headers = PRODUCTIVE_CONF['auth_info']

    def self.get(req_params = {})
      cache_key = "httparty_cache/#{req_params}"

      cached_result = Rails.cache.read(cache_key)

      if cached_result.nil?
        Rails.logger.info("HTTP Request: #{@@endpoint}/#{req_params}")

        # response is a HTTParty.Response object
        response = HTTParty.get("#{@@endpoint}/#{req_params}", headers: @@headers)

        # uniformly convert to an OpenStruct object, with response code and body
        # http_response = OpenStruct.new({"code"=>response.code, "body"=>JSON.parse(response.body)})
        http_response = OpenStruct.new({"code"=>response.code, "body"=>JSON.parse(response.body)})

        Rails.cache.write(cache_key, http_response, expires_in: 1.hour)

        return http_response
      else
        Rails.logger.info("Cached result found for #{cache_key}")
        return cached_result
      end
    end

    def self.post(req_params = {}, payload = {})
      # delete cache after post
      refresh_cache(req_params)

      HTTParty.post("#{@@endpoint}/#{req_params}", body: payload, headers: @@headers)
    end

    def self.patch(req_params = {}, payload = {})
      refresh_cache(req_params)

      HTTParty.patch("#{@@endpoint}/#{req_params}", body: payload, headers: @@headers)
    end

    def self.delete(req_params)
      refresh_cache(req_params)

      HTTParty.delete("#{@@endpoint}/#{req_params}", headers: @@headers)
    end

    private

    def self.refresh_cache(req_params)
      cache_key = "httparty_cache/#{req_params}"

      Rails.cache.delete(cache_key)
      Rails.logger.info("Cache refreshed after POST request for #{cache_key}")
    end
  end
end