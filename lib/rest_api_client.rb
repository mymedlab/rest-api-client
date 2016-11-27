require "rest_api_client/version"
require "rest_api_client/resource"
require "rest_api_client/entity_attribute"
require "rest_api_client/entity"
require "rest_api_client/type_caster"
require "rest_api_client/http_adapters/party"

module RestApiClient
  def self.type_cast_entity(value:, to:)
    return value if value.nil? || to.nil?
    caster = RestApiClient::TypeCaster.new(value)
    caster.value_to_primitive_type(to)
  end

  module Behavior
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def configuration
        @configuration ||= RestApiClient::Configuration.new
      end

      def configure
        yield(configuration)
      end

      def type_cast_entity(value:, to:)
        return value if value.nil? || to.nil?
        caster = RestApiClient::TypeCaster.new(value)
        caster.value_to_primitive_type(to)
      end
    end
  end

  class HTTPError < StandardError
    attr_reader :response
    attr_reader :params
    attr_reader :hint

    def initialize(response, params = {}, hint = nil)
      @response = response
      @params = params
      @hint = hint
      super(response)
    end

    def to_s
      "#{self.class.to_s} : #{response.code} #{response.body}" + (hint ? "\n#{hint}" : "")
    end
  end

  class UnknownTypeError < StandardError; end
  class RateLimited < HTTPError; end
  class NotFound < HTTPError; end
  class Unavailable < HTTPError; end
  class InformApiProvider < HTTPError; end
  class BadRequest < HTTPError; end
  class ServerError < HTTPError; end
  class AuthenticationFailed < HTTPError ; end
end
