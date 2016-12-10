module RestApiClient
  class Configuration
    include ActiveSupport::Configurable

    config_accessor(:base_url)
    config_accessor(:default_headers)
    config_accessor(:default_params)
    config_accessor(:auth)
    config_accessor(:logger)

    def configure(attributes = {})
      attributes.each_pair do |key, value|
        self.send("#{key}=", value)
      end
    end
  end
end
