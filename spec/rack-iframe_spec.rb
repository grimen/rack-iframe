require 'spec_helper'
require 'digest/md5'
require 'time'

# == References:
#   - http://grack.com/blog/2010/01/06/3rd-party-cookies-dom-storage-and-privacy/

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
      @app_headers = {'Content-Type' => 'text/plain'}
      @app_body = %()
      @app = lambda { |env| [200, @app_headers, [@app_body]] } # TODO: Customize
    end

    describe "without Rack::Iframe" do
      before do
        @user_agents = [:ie, :safari, :chrome, :firefox, :opera]
      end

      it 'should not send P3P-headers' do
        @user_agents.each do |user_agent|
          request = mock_request_from_user_agent(user_agent)
          response = @app.call(request)

          headers(response).key?('P3P').must_equal false
        end
      end
    end

    describe "with Rack::Iframe" do
      describe "browsers: IE, Safari" do
        before do
          @user_agents = [:ie, :safari]
        end

        describe "without any HTTP-cache headers" do
          it 'should send P3P-header' do
            @user_agents.each do |user_agent|
              request = mock_request_from_user_agent(user_agent)
              response = Rack::Iframe.new(@app).call(request)

              headers(response).key?('P3P').must_equal true
              headers(response)['P3P'].must_equal %(CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV")
            end
          end
        end

        describe "with HTTP-cache header: Etag" do
          # TODO
        end

        describe "with HTTP-cache header: Last-Modified" do
          # TODO
        end
      end

      describe "browsers: Chrome, Firefox, Opera" do
        before do
          @user_agents = [:chrome, :firefox, :opera]
        end

        describe "without any HTTP-cache headers" do
          it 'should not send P3P-header' do
            @user_agents.each do |user_agent|
              request = mock_request_from_user_agent(user_agent)
              response = Rack::Iframe.new(@app).call(request)

              headers(response).key?('P3P').must_equal false
            end
          end
        end

        describe "with HTTP-cache header: Etag" do
          # TODO
        end

        describe "with HTTP-cache header: Last-Modified" do
          # TODO
        end
      end
    end
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

    def bogus_etag
      Digest::MD5.hexdigest(Time.now.to_s)
    end
    alias :bogus_if_none_match :bogus_etag

    def bogus_last_modified
      Time.now.rfc2822
    end
    alias :bogus_if_modified_since :bogus_last_modified

    def response_etag(response)
      if block_given?
        old_last_modified = headers(response)['Etag']
        headers(response)['Etag'] = bogus_etag
        yield
        headers(response)['Etag'] = old_last_modified
      else
        headers(response)['Etag'] = bogus_etag
      end
    end

    def response_last_modified(response)
      if block_given?
        old_last_modified = headers(response)['Last-Modified']
        headers(response)['Last-Modified'] = bogus_last_modified
        yield
        headers(response)['Last-Modified'] = old_last_modified
      else
        headers(response)['Last-Modified'] = bogus_last_modified
      end
    end

    def request_if_none_match(request)
      if block_given?
        old_last_modified = request.env['HTTP_IF_NONE_MATCH']
        request.env['HTTP_IF_NONE_MATCH'] = bogus_etag
        yield
        request.env['HTTP_IF_NONE_MATCH'] = old_last_modified
      else
        request.env['HTTP_IF_NONE_MATCH'] = bogus_etag
      end
    end

    def request_if_modified_since(request)
      if block_given?
        old_last_modified = request.env['HTTP_IF_MODIFIED_SINCE']
        request.env['HTTP_IF_MODIFIED_SINCE'] = bogus_etag
        yield
        request.env['HTTP_IF_MODIFIED_SINCE'] = old_last_modified
      else
        request.env['HTTP_IF_MODIFIED_SINCE'] = bogus_etag
      end
    end

    # TODO: Use "more real" HTTP_USER_AGENT values.
    def user_agent_string(id)
      case id
      when :ie
        'MSIE'
      when :safari
        'Safari'
      when :chrome
        'Chrome'
      when :opera
        'Opera'
      when :firefox
        'Firefox'
      else
        raise "Define mising browser agent: #{id.inspect}"
      end
    end

    def mock_request_from_user_agent(user_agent_key)
      Rack::MockRequest.env_for('/', {'HTTP_USER_AGENT' => user_agent_string(user_agent_key)})
    end

end
