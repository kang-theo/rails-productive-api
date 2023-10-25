# require 'json'

class Api::V1::ProjectsController < ApplicationController
  def index
    # response = HTTParty.get("https://api.productive.io/api/v2/projects", :headers => {
    #   "X-Organization-Id" => "26018",
    #   "Content-Type" => "application/vnd.api+json",
    #   "X-Auth-Token" => "bc415e7d-52e0-4532-82f5-d924c3a9afe6"
    # }
    response = HTTParty.get("https://api.productive.io/api/v2/projects", :headers => set_headers)

    # puts result
    # puts result["data"]
    # json_result = JSON.parse(result.data)
    # puts json_result
    result = response.parsed_response["data"]
    puts result

    result.each do |hash|
      puts hash["id"] + " " + hash["type"]
    end

    render json: {}, status: 200
  end

  def show
    puts set_headers
  end
end
