class ProjectClient < ProductiveClient
  include Base::ReqParamBuilder

  attr_accessor :id, :new_name, :data

  def initialize(id, new_name)
    @id = id
    @new_name = new_name
  end

  def update()
    response = self.class.http_patch(__method__, set_payload(new_name), set_option_headers(), id)
    print(response)
  end

  def archive()
    response = HTTParty.patch(Base.set_uri("archive", id, @@uri), Base.set_options(archive_body))
    pp response
  end

  # def restore()
  #   response = HTTParty.patch(Base.set_uri("restore", id, @@uri), Base.set_options(restore_body))
  #   pp response
  # end

  # def delete()
  #   response = HTTParty.delete(Base.set_uri("delete", id, @@uri), Base.set_options(delete_body))
  #   pp response
  # end

  # def copy()
  #   response =  HTTParty.patch(Base.set_uri("copy", id, @@uri), Base.set_options(copy_body))
  #   @data = response.parsed_response["data"]
  #   pp @data
  # end

  # methods below are related to both workflow and project, should not be here, 
  # which will influence the class abstraction
  def self.change_workflow()
    # response =  HTTParty.patch(Base.set_uri("", id, @@uri), Base.set_options(copy_body))
    # @data = response.parsed_response["data"]
    # pp @data
  end

  def self.map_to_workflow()
    # response =  HTTParty.patch(Base.set_uri("", id, @@uri), Base.set_options(copy_body))
    # @data = response.parsed_response["data"]
  end

end