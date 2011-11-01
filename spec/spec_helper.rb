# -*- encoding: utf-8 -*-
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/spec'
require 'minitest/pride'

require 'rack/test'
require 'rack/mock'

require 'sinatra'
require 'rack/cache'
require 'chronic'
require 'awesome_print'
require 'digest/md5'
require 'time'

require 'rack/iframe'

ENV['RACK_ENV'] = 'test'

class CachedApp < Sinatra::Base

  use Rack::Cache, :verbose => true, :meta_store => 'heap:/', :entitystore => 'heap:/'

  get '/' do
    headers['Content-Type'] = 'text/plain'
    ""
  end

  get '/etag' do
    headers['Etag'] = '123'
    headers['Content-Type'] = 'text/plain'
    ""
  end

  get '/last_modified' do
    headers['Last-Modified'] = Chronic.parse('0 minutes ago')
    headers['Content-Type'] = 'text/plain'
    ""
  end
end

def mock_app(headers = {}, env = {})
  default_headers = headers.merge({
      'Content-Type' => 'text/plain'
    })
  body = block_given? ? [yield] : ['']
  app = proc { [200, default_headers.merge(headers), body] }
  rack_cache(app)
end

def rack_cache(app, options = {})
  options = {:verbose => true, :meta_store => 'heap:/', :entitystore => 'heap:/'}.merge(options)
  Rack::Cache.new(app, options)
end

def mock_request(user_agent_key, env = {}, path = '/')
  headers = {
      'HTTP_USER_AGENT' => user_agent_string(user_agent_key)
    }.merge(env)
  Rack::MockRequest.env_for(path, headers)
end

def random_etag
  Digest::MD5.hexdigest(Time.now.to_s)
end

def random_date
  Time.now.rfc2822
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

def all_user_agents
  [:ie, :safari, :chrome, :firefox, :opera]
end

# REVIEW: Use or nuke?
def set_env!(request, env_key, value)
  if block_given?
    old_value = request.env[env_key]
    request.env[env_key] = value
    yield
    request.env[env_key] = old_value
  else
    request.env[env_key] = value
  end
end
