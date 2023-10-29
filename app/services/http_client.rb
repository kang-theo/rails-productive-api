require 'uri'
require 'net/http'
require 'net/https'
require 'logutils'

module HttpClient
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end

  # HttpClient.get('...')
  def self.get(url, opt={})
    Request.new.get(url, opt)
  end

  def self.post(url, payload=nil, opt={})
    Request.new.post(url, payload, opt)
  end

  def self.patch(url, payload={}, opt={})
    Request.new.patch(url, payload, opt)
  end

  # def self.put(url, payload={}, opt={})
  # end

  # def self.delete(url, payload)
  # end


  class Error < StandardError
  end

  class HttpError < Error
    attr_reader :code, :message

    def initialize( code, message )
      @code, @message = code, message
    end

    def to_s
      "HTTP request failed: #{@code} #{@message}"
    end
  end

  class Request
    include Base::ReqParamBuilder

    # logger.info, logger.debug ...
    include LogUtils::Logging

    def initialize
      @cache = {}
      @use_cache = false
    end

    def clear_cache()
      @cache = {}
    end

    def cache()
      @cache
    end

    def use_cache=(true_or_false)
      @use_cache = true_or_false
    end

    def use_cache?()
      @use_cache
    end

    def send_request(url, method, payload=nil, opt={})
      logger.debug "HttpClient - #{method} url: #{url}, opt: #{opt}"
      response =  case method
                    when 'GET'    then get_response( url, method, nil, opt )
                    when 'POST'   then get_response( url, method, payload, opt )
                    when 'PUT'    then get_response( url, method, payload, opt )
                    when 'PATCH'  then get_response( url, method, payload, opt )
                    when 'DELETE' then get_response( url, method, nil, opt )
                  end
      # Error
      if response.code != '200' && response.code != '201'
        raise HttpError.new( response.code, response.message )
      end

      response.body
    rescue HttpError => e
      {'status_code' => e.code, 'message' => e.message}
    end

    def get( url, opt={} )
      send_request(url, 'GET', nil, opt)
    end

    def post(url, payload=nil, opt={})
      send_request(url, 'POST', payload, opt)
    end

    def patch(url, payload=nil, opt={})
      send_request(url, 'PATCH', payload, opt)
    end

    def put(url, payload=nil, opt={})
      send_request(url, 'PUT', payload, opt)
    end

    def delete(url, payload=nil, opt={})
      send_request(url, 'DELETE', nil, opt)
    end

    def get_response( url, method='GET', payload=nil, opt={} )
      uri = URI.parse( url )

      proxy = ENV['HTTP_PROXY']
      proxy = ENV['http_proxy'] if proxy.nil?

      if proxy
        proxy = URI.parse( proxy )
        logger.debug "using net http proxy: proxy.host=#{proxy.host}, proxy.port=#{proxy.port}"
        if proxy.user && proxy.password
          logger.debug "using credentials: proxy.user=#{proxy.user}, proxy.password=****"
        else
          logger.debug "using no credentials"
        end
      else
        logger.debug "using direct net http access; no proxy configured"
        # eg. proxy.host -> nil
        proxy = OpenStruct.new
      end

      http_proxy = Net::HTTP::Proxy( proxy.host, proxy.port, proxy.user, proxy.password )
      
      redirect_limit = 6
      response = nil

      until false
        raise ArgumentError, 'HTTP redirects too much times' if redirect_limit == 0
        redirect_limit -= 1

        http = http_proxy.new( uri.host, uri.port )

        logger.debug "GET #{uri.request_uri} uri=#{uri}, redirect_limit=#{redirect_limit}"

        # headers setting
        headers = set_auth_headers()
        puts headers

        unless opt['headers'].nil?
          headers.merge!(opt['headers'].to_h)
        end
        
        if use_cache?
          cache_entry = cache[uri.to_s]
          if cache_entry
            logger.info "found cache entry for >#{uri.to_s}<"
            if cache_entry['etag']
              logger.info "adding header If-None-Match (etag) >#{cache_entry['etag']}< for conditional GET"
              headers['If-None-Match'] = cache_entry['etag']
            end

            if cache_entry['last-modified']
              logger.info "adding header If-Modified-Since (last-modified) >#{cache_entry['last-modified']}< for conditional GET"
              headers['If-Modified-Since'] = cache_entry['last-modified']
            end
          end
        end

        # https://ruby-doc.org/stdlib-3.0.0/libdoc/net/http/rdoc/Net/HTTP.html
        request = case method
                    when 'GET'    then Net::HTTP::Get.new( uri.request_uri, headers )
                    when 'POST'   then Net::HTTP::Post.new( uri.request_uri, headers )
                    when 'PUT'    then Net::HTTP::Put.new( uri.request_uri, headers )
                    when 'PATCH'  then Net::HTTP::Patch.new( uri.request_uri, headers )
                    when 'DELETE' then Net::HTTP::Delete.new( uri.request_uri, headers )
                  end
        
        # HTTP or HTTPs
        if uri.instance_of? URI::HTTPS
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        puts request
        puts payload
        request.body = 
        response = http.request( request, payload )

        if response.code == '200' || response.code == '201'
          logger.debug "#{response.code} #{response.message}"
          logger.debug "  content_type: #{response.content_type}, content_length: #{response.content_length}"
          # break return response
          break
        elsif( response.code == '304' ) 
          # -- Not Modified(404) -
          logger.debug "#{response.code} #{response.message}"
          break
        elsif( response.code == '301' || response.code == '302' || response.code == '303' || response.code == '307' )
          logger.debug "#{response.code} #{response.message} location=#{response.header['location']}"
          newuri = URI.parse( response.header['location'] )

          if newuri.relative?
            logger.debug "url relative; try to make it absolute"
            newuri = uri + response.header['location']
          end
          uri = newuri
        else
          # 40x, 50x
          puts "** error - HttpClient - #{response.code} #{response.message} **"
          break
        end
      end

      response
    end

  end

end