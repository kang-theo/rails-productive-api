ProductiveConf.configure do |config|
  config.endpoint = 'https://api.productive.io/api/v2'.freeze

  config.auth_info = {
    "X-Auth-Token": Rails.application.credentials.productive_api_token,
    "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
    "Content-Type": 'application/vnd.api+json'
  }.freeze

  config.relationships = [
    # { entity: 'Project', path: 'projects' },
    # { entity: 'Company', path: 'companies' },
    # { entity: 'Organization', path: 'organizations' },
    # { entity: 'Membership', path: 'memberships' },
    # { entity: 'People', path: 'people' },
    { type: 'projects', entity: 'Project' },
    { type: 'companies', entity: 'Company' },
    { type: 'organizations', entity: 'Organization' },
    { type: 'memberships', entity: 'Membership' },
    { type: 'people', entity: 'Person' },
  ].freeze
end

class ProductiveConf
  class << self
    attr_accessor :endpoint, :auth_info, :relationships

    def configure
      yield self if block_given?
    end
  end
end
