module Authentication
  extend ActiveSupport::Concern

  # def self.included base
  #   base.class_eval do
  #     helper_method :set_headers
  #   end
  # end

  def set_headers
    {
      "X-Auth-Token" => "bc415e7d-52e0-4532-82f5-d924c3a9afe6",
      "X-Organization-Id" => "26018",
      "Content-Type" => "application/vnd.api+json"
    }
  end
end