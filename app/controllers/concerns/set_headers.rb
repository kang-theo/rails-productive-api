module SetHeaders
  extend ActiveSupport::Concern

  # def self.included base
  #   base.class_eval do
  #     helper_method :set_headers
  #   end
  # end

  # for bulk request, set is_bulk to true
  def set_auth_headers is_bulk=false
    {
      "X-Auth-Token" => "0b74561b-0d18-4996-bb69-7ffa59a40681",
      "X-Organization-Id" => "30897",
      "Content-Type" => (is_bulk ?  "application/vnd.api+json; ext=bulk" : "application/vnd.api+json")
    }
  end

  def set_body_headers
    auth_headers = set_auth_headers
    body_headers = 
      { 
        "Accept" => "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5"
      }
    auth_headers.merge(body_headers)
  end

end