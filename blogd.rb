# encoding: utf-8
require 'oauth'
require 'uri'
require_relative './f'

# have to patch OAuth so binary upload is possible
module OAuth
  module Helper
    extend self
    def escape(value)
      URI::escape(value.to_s, OAuth::RESERVED_CHARACTERS)
    rescue ArgumentError
      # (changed Encoding::UTF_8 to Encoding::ASCII_8BIT)
      URI::escape(value.to_s.force_encoding(Encoding::ASCII_8BIT), OAuth::RESERVED_CHARACTERS)
    end
  end
end

raise RuntimeError, "Specify image files" if ARGV.length < 1

filename = ARGV[0]
tags = ARGV[1] || ""

print "posting #{filename}... "
consumer = OAuth::Consumer.new(
  CONSUMER_KEY, SECRET_KEY,
  :site               => "https://www.tumblr.com/",
  :access_token_path  => "/oauth/access_token",
  :http_method        => :post,
)

access_token = consumer.get_access_token(
  nil, {},
  :x_auth_mode => 'client_auth',
  :x_auth_username => EMAIL,
  :x_auth_password => PASSWORD,
)

print "got token, sending request... "
response = access_token.post(
  "http://api.tumblr.com/v2/blog/#{BLOG_URL}/post",
  "generator" => "tumbl.rb",
  "type"      => "photo",
  "private"   => "0",
  "slug"      => "",
  "state"     => "",
  "tags"      => tags,
  "data"      => IO.binread(filename),
)

puts response.body
