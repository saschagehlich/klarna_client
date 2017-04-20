module Klarna
  class Configuration
    attr_accessor :environment, :country, :api_key, :api_secret, :version, :debugger, :user_agent

    def initialize
      @country = :us
      @environment = :production
      @endpoints = {
        us: {
          test: "https://api-na.playground.klarna.com",
          production: "https://api-na.klarna.com"
        },
        eu: {
          test: "https://api.playground.klarna.com",
          production: "https://api.klarna.com"
        },
        de: {
          test: "https://api.playground.klarna.com",
          production: "https://api.klarna.com"
        },
        uk: {
          test: "https://api.playground.klarna.com",
          production: "https://api.klarna.com"
        }
      }
      @version = :v1
      @debugger = false #$stdout
    end

    def endpoint
      @endpoints[@country.to_sym][@environment.to_sym]
    end
  end
end
