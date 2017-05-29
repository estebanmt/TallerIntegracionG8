require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'

class APIBase
  @@key = '2T02j&xwE#tQA#e'
  #@key = ENV["CLAVE_BODEGA"]

  #@URL_API_BODEGA = 'https://integracion-2017-dev.herokuapp.com/bodega/'
  @@URL_API_BODEGA = ENV["URL_API_BODEGA"]


  def initialize()

  end

  def self.doHashSHA1(authorization)
    puts "key #{@@key}"
    puts authorization
    digest = OpenSSL::Digest.new('sha1')

    hmac = OpenSSL::HMAC.digest(digest, @@key, authorization)
    puts hmac
    return Base64.encode64(hmac)
  end



end