require 'rails_helper'

RSpec.describe Productive::HttpClient, type: :request do
  let(:endpoint) { PRODUCTIVE_CONF['endpoint'] }
  let(:auth_info) { PRODUCTIVE_CONF['auth_info'] }
  let(:headers) do
    auth_info.merge!({ 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'User-Agent' => 'Ruby' })
  end

  describe '.get' do
    let(:path) { 'projects' }
    let(:id) { '388797' }

    context 'http request' do
      let(:api_response) { File.read('spec/fixtures/response.json') }
      let(:not_found) { File.read('spec/fixtures/404_not_found.json') }

      before do
        # Stub: reduce the variation
        allow(Rails).to receive_message_chain(:cache, :read).and_return(nil)
        allow(Rails).to receive_message_chain(:cache, :write).and_return(nil)
      end

      it 'converts response to unified format with code and body' do
        # WebMock
        stub_request(:get, %r{#{Regexp.quote(endpoint)}/.*})
          .with(headers: headers)
          .to_return(status: 200, body: api_response, headers: { 'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

        # Act
        # # 1. get response from WebMock
        # response = HTTParty.get("#{endpoint}/#{path}/#{id}", headers: headers)
        # # 2. unified response in HttpClient for different libraries like HTTParty, Faraday, etc.
        # http_response = OpenStruct.new('code'=>response.code, 'body'=>JSON.parse(response.body))
        response = Productive::HttpClient.get("#{endpoint}/#{path}/#{id}")

        # Assert
        expect(response.code).to eq(200)
        expect(response.body).to eq(JSON.parse(api_response))
      end

      it 'not found with invalid request params' do
        stub_request(:get, %r{#{Regexp.quote(endpoint)}/.*})
          .with(headers: headers)
          .to_return(status: 400, body: not_found, headers: { 'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

        response = Productive::HttpClient.get("#{endpoint}/bad/path")

        expect(response.code).to eq(400)
        expect(response.body).to eq(JSON.parse(not_found))
      end
    end

    context 'cache test' do
      # it 'first request should be cached' do

      # end
    end
  end

  describe '.post' do
    context 'http request' do
      let(:new_project) { File.read('spec/fixtures/response.json') }
      let(:payload) { File.read('spec/fixtures/payload_for_create.json') }

      before do
        allow(Productive::HttpClient).to receive(:refresh_cache).and_return(nil)
      end

      it 'creates a new resource and return the response' do
        # WebMock
        stub_request(:post, %r{#{Regexp.quote(endpoint)}/.*})
          .with(body: payload, headers: headers)
          .to_return(status: 200, body: new_project, headers: { 'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

        # Act
        response = Productive::HttpClient.post("#{endpoint}/#{path}", payload)

        # Assert
        expect(response.code).to eq(200)
        expect(response.body).to eq(JSON.parse(new_project))
      end
    end
  end

  describe '.patch' do
    context 'http request' do
      let(:update_project) { File.read('spec/fixtures/response.json') }
      let(:payload) { File.read('spec/fixtures/payload_for_create.json') }

      before do
        allow(Productive::HttpClient).to receive(:refresh_cache).and_return(nil)
      end

      it 'update a resource and return the response' do
        # WebMock
        stub_request(:patch, %r{#{Regexp.quote(endpoint)}/.*})
          .with(body: payload, headers: headers)
          .to_return(status: 200, body: update_project, headers: { 'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

        # Act
        response = Productive::HttpClient.patch("#{endpoint}/#{path}", payload)

        # Assert
        expect(response.code).to eq(200)
        expect(response.body).to eq(JSON.parse(update_project))
      end
    end
  end

  # describe '.delete' do
  #   context 'http request' do

  #   end
  # end

  describe '.parse_response' do
    let(:valid_data) { File.read('./spec/fixtures/response.json') }
    let(:invalid_data) { File.read('./spec/fixtures/response.xml') }

    it 'valid response format, does not raise an error' do
      expect do
        Productive::HttpClient.parse_response { JSON.parse(valid_data) }
      end.to_not raise_error
    end

    it 'invalid response format, raise an exception' do
      expect do
        Productive::HttpClient.parse_response { JSON.parse(invalid_data) }
      end.to raise_error(ApiResponseError, /Invalid JSON response from API/)
    end
  end
end