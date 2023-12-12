require 'rails_helper'

RSpec.describe Productive::HttpClient, type: :request do
  let(:endpoint){ PRODUCTIVE_CONF['endpoint'] }
  let(:auth_info){ PRODUCTIVE_CONF['auth_info'] }
  let(:headers){ auth_info.merge!({'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}) }

  describe '.get' do
    let(:path){ 'projects' }
    let(:id){ '388797' }

    context 'http request' do
      let(:api_response){ File.read('spec/fixtures/response.json') }
      let(:not_found){ File.read('spec/fixtures/404_not_found.json') }

      before do
        # Stub: reduce the variation
        allow(Rails).to receive_message_chain(:cache, :read).and_return(nil)
        allow(Rails).to receive_message_chain(:cache, :write).and_return(nil)
      end

      it 'converts response to unified format with code and body' do
        # WebMock
        stub_request(:get, %r{#{Regexp.quote(endpoint)}/.*})
          .with(headers: headers)
          .to_return(status: 200, body: api_response, headers: {'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

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
          .with(body: payload, headers: headers)
          .to_return(status: 400, body: not_found, headers: {'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

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
      let(:new_project){ File.read('spec/fixtures/response.json') }
      let(:payload){ File.read('spec/fixtures/payload_for_create.json') }

      before do
        allow(Productive::HttpClient).to receive(:refresh_cache).and_return(nil)
      end

      it 'creates a new resource and return the response' do
        # WebMock
        stub_request(:post, %r{#{Regexp.quote(endpoint)}/.*})
          .with(body: payload, headers: headers)
          .to_return(status: 200, body: new_project, headers: {'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

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
      let(:update_project){ File.read('spec/fixtures/response.json') }
      let(:payload){ File.read('spec/fixtures/payload_for_create.json') }

      before do
        allow(Productive::HttpClient).to receive(:refresh_cache).and_return(nil)
      end

      it 'update a resource and return the response' do
        # WebMock
        stub_request(:patch, %r{#{Regexp.quote(endpoint)}/.*})
          .with(body: payload, headers: headers)
          .to_return(status: 200, body: update_project, headers: {'Content-Type' => 'application/vnd.api+json; charset=utf-8' })

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

  # describe '.parse_response' do
  #   context 'when the block execution is successful' do
  #     let(:data){ File.read('./spec/fixtures/response.json') }

  #     it 'does not raise an error' do
  #       expect do
  #         Productive::Parser.parse_response do
  #           JSON.parse(data).dig('data')
  #         end
  #       end.to_not raise_error
  #     end
  #   end

  #   context 'when the block execution raises JSON::ParserError' do
  #     let(:data) { File.read('./spec/fixtures/response.xml') } 

  #     it 'rescues the error and logs it' do
  #       allow(Rails.logger).to receive(:error)

  #       response_data = Productive::Parser.parse_response do
  #         JSON.parse(data).dig('data')
  #       end

  #       # TODO: process exception instantly, logger and find it after a long time is not a good idea. The jason respon is also not a normal way.
  #       expect(Rails.logger).to have_received(:error).with(/JSON::ParserError: unexpected token/)
  #       expect(response_data).to eq({ error: 'JSON::ParserError', status: :bad_response })
  #     end
  #   end
  # end
end