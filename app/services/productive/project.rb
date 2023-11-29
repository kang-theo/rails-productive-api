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
        # TODO: 代码重复，最后想要的效果是，直接调用 archive 就行了，这些代码看是否提取到父类中
        response = HttpClient.patch("#{path}/#{id}/archive")
        Parser.handle_response(response, self)
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
        Parser.handle_response(response, self)
      end

    # Delete the entity by sending a DELETE request to the API.
      #
      # @return [Object] The deleted entity.
      #
      # Example:
      #   p = Productive::Project.find(399787)
      #   p.delete
      def delete
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
        response = HttpClient.post("#{path}/copy", build_payload(attrs))
        Parser.handle_response(response, self)
      end
  end
end