module RestApiClient
  class Resource
    attr_reader :last_response
    attr_reader :last_request

    def self.root(value = nil)
      if value.present?
        @root = value
      else
        @root
      end
    end

    def self.entity_class(value = nil)
      if value.present?
        @entity_class = value
      else
        @entity_class
      end
    end

    def initialize(configuration)
      @configuration = configuration
      @adapter = RestApiClient::HttpAdapters::Party.new(configuration)
    end

    private

    def post(path:, body:, query: {}, headers: {})
      process_request(method: :post, path: path, body: body, headers: headers)
    end

    def get(path:, query: {}, headers: {})
      process_request(method: :get, path: path, query: query, headers: headers)
    end

    def process_request(method:, path:, body: {}, query: {}, headers: {})
      @response = @adapter.execute(
        method: method,
        path: path,
        body: body,
        query: query,
        headers: headers
      )

      params = {
        path: path,
        options: {
          body: body,
          query: @configuration.default_params.merge(query),
        },
        method:  method
      }

      @last_response = @response
      @last_request = @response.request

      params[:response] = @response.inspect.to_s rescue @response.body

      if @configuration.logger
        @configuration.logger.call(@response)
      end

      case @response.code
      when 200..201
        @response
      when 400
        raise RestApiClient::BadRequest.new(@response, params)
      when 401
        exception = RestApiClient::AuthenticationFailed.new(@response, params)
        binding.pry
        raise exception
      when 404
        raise RestApiClient::NotFound.new(@response, params, "Do you have sufficient privileges?")
      when 500
        raise RestApiClient::ServerError.new(@response, params)
      when 502
        raise RestApiClient::Unavailable.new(@response, params)
      when 503
        raise RestApiClient::RateLimited.new(@response, params)
      else
        raise RestApiClient::InformApiProvider.new(@response, params)
      end
    end

    def response_to_entity_collection(response)
      response[collection_root].map do |order|
        entity_class.new(order[root].symbolize_keys)
      end
    end

    def response_to_entity(response)
      attrs = response[root].symbolize_keys
      entity_class.new(attrs)
    end

    def root
      @root ||= self.class.root
    end

    def entity_class
      @entity_class ||= self.class.entity_class.constantize
    end

    def collection_root
      @collection_root ||= root.pluralize
    end
  end
end
