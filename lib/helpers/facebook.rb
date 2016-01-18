#!/usr/bin/env ruby
# encoding:utf-8
require 'net/http'
require 'json'
require 'uri'
require 'pp'

module Facebook
  class << self
    FACEBOOK_API_URL   = 'http://api.facebook.com/'.freeze
    QUERY              = 'method/links.getStats?urls=#query#&format=json'.freeze
    UNKNOWN            = 'neznámy'.freeze

    def data(url)
      uri = URI(url)
      path = uri.path
      if uri.host
        stripped = path.to_s.strip.length
        results = inside_check(stripped, url)
      else
        results = unknown_res(url)
      end
      results[0]
    end

    def correct_res(url)
      results = []
      query_updated = QUERY.gsub(/#query#/, url)
      content = Net::HTTP.get(URI(FACEBOOK_API_URL + query_updated))
      json_hash = JSON.parse(content)
      results << {
        'host' => URI(url).host, # base domain,
        'url' => url,
        'article_likes' => json_hash[0]['like_count'], # likes_count
        'article_shares' => json_hash[0]['share_count'] # shares_count
      }
    end

    def unknown_res(url)
      [{
        'host' => UNKNOWN, # base domain,
        'url' => url,
        'article_likes' => UNKNOWN, # likes_count
        'article_shares' => UNKNOWN # shares_count
      }]
    end

    def inside_check(stripped_path, url)
      req = Net::HTTP.new(URI(url).host, URI(url).port)
      if stripped_path == 0 || stripped_path == 1
        correct_res(url)
      else
        res = req.request_head(path)
        unknown_res(url) if res.code != '202'
      end
    end
  end
end
