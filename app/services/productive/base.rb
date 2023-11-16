# frozen_string_literal: true

class Productive::Base
  # @@relations = {
  #   Project: 'projects',
  #   Company: 'companies',
  #   Organization: 'organizations',
  #   Person: 'people',
  #   Membership: 'memberships'
  # }
  

  # move to ProductiveConf
  endpoint = 'https://api.productive.io/api/v2' 
  auth_info = {
    "X-Auth-Token": Rails.application.credentials.productive_api_token,
    "X-Organization-Id": Rails.application.credentials.organization_id.to_s,
    "Content-Type": 'application/vnd.api+json'
  }

  class << self
    attr_accessor :http_client
  end
  # a better way
  @@http_client = HttpClient.new(endpoint, auth_info)
  def self.http_client
    @@http_client
  end

  def initialize(attributes, foreign_key_types)
    raise "ApiRequestError: attributes is blank" if attributes.blank?
    raise "ApiRequestError: foreign_key_types is blank" if foreign_key_types.blank?

    create_setter_and_getter(attributes)
    define_association_methods(attributes, foreign_key_types)
  end

  # usage: Project.all, Company.all
  def self.all
    req_params = "#{self.name.demodulize.downcase.pluralize}"
    http_client.get(req_params)
  end

  def self.find(id)
    raise ApiRequestError, 'Id is invalid.' if id.nil?

    # lookup according to config
    req_params = "#{self.name.demodulize.downcase.pluralize}/#{id}"
    response = http_client.get(req_params)
    parser = Productive::ProductiveParser.new(response, self.name.demodulize) # refactor the module structure, instead of using a folder as a namespace
    entity = parser.handle_response
    return nil if entity.nil?
    entity.first
  end

  private

  def create_setter_and_getter(attributes)
    # define setters and getters for instance attributes
    attributes.each do |key, value|
      instance_variable_set("@#{key}", value)

      self.class_eval do
        define_method(key) do
          instance_variable_get("@#{key}")
        end

        define_method("#{key}=") do |value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end

  def define_association_methods(attributes, types)
    types.each do |type|
      ids = attributes[(type.singularize+'_id').to_sym]
      method_name = type.singularize
      klass = method_name.capitalize

      # define association methods for company, organization, etc. according to each entity's foreign_keys
      if ids.is_a?(Array) # define association methods for multiple memberships, etc.
        self.class.class_eval do
          define_method(method_name.to_sym) do
            ids.map do |id|
              Object.const_get('Productive::' + klass).find(id)
            end
          end
        end
      else
        self.class.class_eval do
          define_method(method_name.to_sym) do
            Object.const_get('Productive::' + klass).find(ids)
          end
        end
      end
    end

  end

end
