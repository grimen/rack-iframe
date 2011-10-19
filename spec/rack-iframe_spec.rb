require 'spec_helper'

describe Rack::Iframe do

  describe "VERSION" do
    it 'should be defined' do
      defined?(::Rack::Iframe::VERSION)
    end

    it 'should be a valid version string (e.g. "0.0.1", or "0.0.1.rc1")' do
      valid_version_string = /^\d+\.\d+\.\d+/
      Rack::Iframe::VERSION.must_match valid_version_string
    end
  end

  describe "Middleware" do
    before do
      @app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [""]] } # TODO: Customize
    end

    # TODO: "The specs" :)
  end

  private

    def status(response)
      response[0]
    end

    def headers(response)
      response[1]
    end

    def body(response)
      response[2]
    end

end