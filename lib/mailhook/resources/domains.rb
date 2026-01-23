# frozen_string_literal: true

module Mailhook
  module Resources
    # Resource for managing domains.
    #
    # @example Create a domain
    #   domain = client.domains.create(slug: "mycompany")
    #   puts domain["domain"]  # => "mycompany.tail.me"
    #
    # @example List all domains
    #   domains = client.domains.list
    #   domains.each { |d| puts d["domain"] }
    class Domains < Resource
      # Create a new shared domain (tail.me subdomain)
      # @param slug [String] The subdomain slug (e.g., "mycompany" creates "mycompany.tail.me")
      # @return [Response] Created domain details
      def create(slug:)
        post("domains", { domain_type: "shared", tailme_slug: slug })
      end

      # List all domains
      # @param page [Integer, nil] Page number for pagination
      # @param per_page [Integer, nil] Number of items per page
      # @return [Response] List of domains
      def list(page: nil, per_page: nil)
        get("domains", clean_params({ page: page, per_page: per_page }))
      end

      # Retrieve a domain by ID
      # @param id [String, Integer] Domain ID
      # @return [Response] Domain details
      def retrieve(id)
        get("domains/#{id}")
      end

      # Delete a domain
      # @param id [String, Integer] Domain ID
      # @return [Response] Deletion confirmation
      def delete(id)
        super("domains/#{id}")
      end

      # Check if a slug is available
      # @param slug [String] The subdomain slug to check
      # @return [Response] Availability status
      def check_slug(slug)
        get("domains/check_slug", { slug: slug })
      end
    end
  end
end
