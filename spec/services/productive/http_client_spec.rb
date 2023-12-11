require 'rails_helper'

RSpec.describe Productive::HttpClient, type: :request do
  describe '.get' do
    let(:endpoint){ PRODUCTIVE_CONF['endpoint'] }
    let(:auth_info){ PRODUCTIVE_CONF['auth_info'] }
    let(:headers){ auth_info.merge!({'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}) }
    let(:path){ 'projects' }
    let(:id){ '388797' }
    let(:api_response){ File.read('spec/fixtures/response.json') }

    context 'successful request' do
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
    end

    # context 'fail request' do
    #   it 'with bad request params' do

    #   end
    # end

    # context 'cache test' do
    #   it 'first request should be cached' do

    #   end
    # end
  end

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