# require 'net/http'
# require 'uri'
class Project < Productive
  attr_accessor :id
  attr_accessor :data
  attr_accessor :errors

  #TODO: use model accessing ways to abstract the api
  # @@uri = ProductiveApi::Base2.model_base_uri + "/projects"
  @@uri = nil

  def initialize(id)
    @id = id
  end

  def self.archive
    begin
      response = HTTParty.patch(Base.set_uri("archive", id, @@uri), Base.set_options(archive_body))
      pp response
    rescue HTTParty::Error
      puts "HTTParty error occurred"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  def self.restore
    begin
      response = HTTParty.patch(Base.set_uri("restore", id, @@uri), Base.set_options(restore_body))
      pp response
    rescue HTTParty::Error
      puts "HTTParty error occurred"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  def self.delete
    begin
      response = HTTParty.delete(Base.set_uri("delete", id, @@uri), Base.set_options(delete_body))
      pp response
    rescue HTTParty::Error
      puts "HTTParty error occurred"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  def self.copy
    begin
      response =  HTTParty.patch(Base.set_uri("copy", id, @@uri), Base.set_options(copy_body))
      @data = response.parsed_response["data"]
      pp @data
    rescue HTTParty::Error
      puts "HTTParty error occurred"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end

  # methods below are related to both workflow and project, should not be here, 
  # which will influence the class abstraction
  def self.change_workflow

  end

  def self.map_to_workflow

  end

end