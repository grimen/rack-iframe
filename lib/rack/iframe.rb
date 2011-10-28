require 'rack'
require 'rack/iframe/version'
require 'digest/md5'

module Rack
  class Iframe

    def initialize(app)
      @app = app
    end

    def call(env)
      # 1) If P3P: Set a random Etag (If-None-Match) to trick backend to not send cached response (304).
      set_invalid_etag!(env) if set_p3p_header?(env)

      # 2) Request
      @status, @headers, @body = @app.call(env)

      # 3) If P3P: Attach P3P header.
      set_p3p_header! if set_p3p_header?(env)

      # 4) Response
      [@status, @headers, @body]
    end

    protected

      def user_agent(env)
        env['HTTP_USER_AGENT']
      end

      def etag(env)
        env['HTTP_IF_NONE_MATCH']
      end

      def last_modified(env)
        env['HTTP_IF_MODIFIED_SINCE']
      end

      def set_invalid_etag!(env)
        env['HTTP_IF_NONE_MATCH'] = Digest::MD5.hexdigest(Time.now.to_s)
      end

      def set_p3p_header!
        @headers['P3P'] = %(CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV")
      end

      # WIP: Handle all cases
      def set_p3p_header?(env)
        user_agent?(:ie, env) || user_agent?(:safari, env)
      end

      def user_agent?(id, env)
        case id
        when :ie
          user_agent(env).include?('MSIE')
        when :safari
          user_agent(env).include?('Safari')
        when :opera
          user_agent(env).include?('Chrome')
        when :opera
          user_agent(env).include?('Opera')
        when :firefox
          user_agent(env).include?('Firefox')
        else
          raise "Define mising browser agent: #{id.inspect}"
        end
      end

      def etag_set?(env)
        etag(env) && etag(env).size
      end

      def last_modified_set?(env)
        last_modified(env) && last_modified(env).size
      end

  end
end
