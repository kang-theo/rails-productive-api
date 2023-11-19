class ProductiveConf
  class << self
    attr_accessor :endpoint, :auth_info, :relationships, :req_params_mapping

    def configure
      yield self if block_given?
    end
  end
end

ProductiveConf.configure do |config|
  # config.endpoint = 'https://api.productive.io/api/v2'.freeze

  # config.auth_info = {
  #   "X-Auth-Token": Rails.application.credentials.productive_api_token,
  #   "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
  #   "Content-Type": 'application/vnd.api+json'
  # }.freeze

  config.relationships = [
    { type: 'projects', entity: 'Project' },
    { type: 'companies', entity: 'Company' },
    { type: 'organizations', entity: 'Organization' },
    { type: 'memberships', entity: 'Membership' },
    { type: 'people', entity: 'Person' }
  ].freeze

  config.req_params_mapping = [
    { entity: 'Productive::Project', path: 'projects' },
    { entity: 'Productive::Company', path: 'companies' },
    { entity: 'Productive::Organization', path: 'organizations' },
    { entity: 'Productive::Membership', path: 'memberships' },
    { entity: 'Productive::People', path: 'people' },
  ].freeze
end
