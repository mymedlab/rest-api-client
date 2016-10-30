module RestApiClient
  module HttpAdapters
    class Party
      def initialize(configuration)
        @configuration = configuration
      end

      def execute(method:, path:, body: {}, query: {}, headers: {})
        httparty_options = {
          body: body,
          headers: @configuration.default_headers.merge(headers),
          verify: false,
          query: @configuration.default_params.merge(query),
        }

        if @configuration.auth[:type] == "http_basic"
          httparty_options[:basic_auth] = @configuration.auth[:credentials]
        end

        HTTParty.send(method, "#{@configuration.base_url}/#{path}", httparty_options)
      end
    end
  end
end
