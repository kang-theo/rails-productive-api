require 'net/http'
require 'json'

module Productive
  module HttpClient
    class ApiIntegration
      def initialize(api_key)
        @api_key = api_key
        @base_url = 'https://api.example.com'
      end

      def make_api_request(endpoint, params = {})
        uri = URI("#{@base_url}/#{endpoint}")
        uri.query = URI.encode_www_form(params.merge(api_key: @api_key))

        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          return JSON.parse(response.body)
        else
          # Handle error cases
          puts "Error: #{response.code}, #{response.message}"
          return nil
        end
      end

      # Other methods related to your API integration can go here
    end

  end
end