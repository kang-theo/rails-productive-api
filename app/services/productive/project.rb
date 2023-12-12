# frozen_string_literal: true

module Productive
  class Project < Base
    # Archives the entity by sending a PATCH request to the API.
    #
    # @return [Object] The archived entity.
    #
    # Example:
    #   p = Productive::Project.find(399787)
    #   p.archive
    def archive
      # TODO: check whether just call archive directly, and abstract these methods to Base class
      response = HttpClient.patch("#{path}/#{id}/archive")
      result = Parser.handle_response(response, self)

      return nil if result.empty?

      result.first
    end

    # Restores the entity by sending a PATCH request to the API.
    #
    # @return [Object] The restored entity.
    #
    # Example:
    #   p = Productive::Project.find(399787)
    #   p. restore
    def restore
      response = HttpClient.patch("#{path}/#{id}/restore")
      result = Parser.handle_response(response, self)

      return nil if result.empty?

      result.first
    end

    # use more meaningful method name, etc. delete = destroy
    # Delete the entity by sending a DELETE request to the API.
    #
    # @return [Object] The deleted entity.
    #
    # Example:
    #   p = Productive::Project.find(399787)
    #   p.destroy
    def destroy
      response = HttpClient.delete("#{path}/#{id}")
      Parser.handle_response(response, self)
    end

    # Copy the entity by sending a POST request to the API.
    #
    # @return [Object] The copied entity.
    #
    # Example:
    #   p = Productive::Project.copy({name: "copied 1", template_id: "399787"})
    def self.copy(attrs)
      response = HttpClient.post("#{path}/copy", payload(attrs))
      Parser.handle_response(response, self)
    end
  end
end