require "net/http"
require "uri"
require "ostruct" # package the status code and deserialized body
require "json"

class HttpConnection

  ENDPOINT = "https://api.productive.io/api/v2"

  VERB_MAP = {
    :get    => Net::HTTP::Get,
    :post   => Net::HTTP::Post,
    :put    => Net::HTTP::Put,
    :delete => Net::HTTP::Delete
  }

  def initialize(path, endpoint = ENDPOINT)
    uri = URI.parse(endpoint + path)
    @http = Net::HTTP.new(uri.host, uri.port)
  end

  def get(path, params)
    request_json :get, path, params
  end

  def post(path, params)
    request_json :post, path, params
  end

  def put(path, params)
    request_json :put, path, params
  end

  def delete(path, params)
    request_json :delete, path, params
  end

  private

  def request_json(method, path, params)
    response = request(method, path, params)
    body = JSON.parse(response.body)

    OpenStruct.new(:code => response.code, :body => body)
  rescue JSON::ParserError
    response
  end

  def request(method, path, params = {})
    case method
    when :get
      full_path = encode_path_params(path, params)
      request = VERB_MAP[method.to_sym].new(full_path)
    else
      request = VERB_MAP[method.to_sym].new(path)
      request.set_form_data(params)
    end

    @http.request(request)
  end

  def encode_path_params(path, params)
    encoded = URI.encode_www_form(params)
    [path, encoded].join("?")
  end

end