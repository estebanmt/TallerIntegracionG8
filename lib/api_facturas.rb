require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require './api_bodega.rb'

class APIFacturas

  @URL_FACTURAS = "https://integracion-2017-dev.herokuapp.com/sii"

  def self.put_url(uri, params, authorization)
    @url = @URL_PAGO_TRANSFERENCIA + uri
    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json#, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    json = JSON.parse(@response.body)
    #puts json
  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key_bodega, authorization)
    #puts hmac
    return Base64.encode64(hmac)
  end


end
