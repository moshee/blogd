require 'net/http'
require 'oauth'
require 'oauth/consumer'
require 'open-uri'
require_relative './f'


#files.each do |file|
#  print "posting #{file.name}... "
  consumer = OAuth::Consumer.new(
    CONSUMER_KEY, SECRET_KEY,
    :site               => "http://www.tumblr.com",
    :request_token_path => "/oauth/request_token",
    :authorize_path     => "/oauth/authorize",
    :access_token_path  => "/oauth/access_token",
    :http_method        => :post,
    :scheme             => :header,
  )

  access_token = OAuth::AccessToken.from_hash consumer, :oauth_token => CONSUMER_KEY
  print "got token, sending request... "
  response = access_token.post(
    "http://api.tumblr.com/v2/blog/animedgifs.tumblr.com/post",
    "generator"    => "tumbl.rb",
    "type"         => "text",
    "body"         => "wtf oauth",
    "private"      => "0",
    "slug"         => "",
    "state"        => "",
    "tags"         => "wtf",
  )
=begin
  response = access_token.post(
    "http://api.tumblr.com/v2/blog/animedgifs.tumblr.com/post",
    "type" => "photo",
    "tags" => file.tags,
    "data" => URI::encode(File.open(file.name).read.force_encoding('ASCII-8BIT')),
  )
=end

  puts response.body

#  exit
#end

