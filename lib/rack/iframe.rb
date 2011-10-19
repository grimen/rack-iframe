require "rack/iframe/version"

module Rack
  class Iframe

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    end

    protected

      # TODO: Helpers

  end
end
