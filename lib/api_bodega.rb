require 'rest_client'
require 'openssl'
require "base64"
require 'digest'

class APIBodega
  @key = '2T02j&xwE#tQA#e'
  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega/'
  @URI_GET_ALMACENES = 'almacenes'
  @GET_SKUS_WITH_STOCK = 'skusWithStock'

  def initialize()


  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
    return Base64.encode64(hmac)
  end

  def self.get_almacenes (almacenId)

    hmac = doHashSHA1('GET'.concat(almacenId))
    params = {:almacenId => almacenId}
    return unique_url(@URI_GET_ALMACENES, params, hmac)

  end

  def self.get_skusWithStock(almacenId)
    hmac = doHashSHA1('GET'.concat(almacenId))
    params = {'almacenId' => almacenId}
    return unique_url(@GET_SKUS_WITH_STOCK, params, hmac)
  end

  def self.add_params

  end


  def self.unique_url(uri, params, authorization)
    #response =  RestClient.Req(@API_URL_DEV.concat(uri), params, {:Content-Type => 'application/json', :Authorization => 'INTEGRACION grupo8:'.concat(authorization)})

    puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    puts @auth

    @url = @API_URL_DEV.concat(uri)
    puts @url

    @response = RestClient::Request.execute(
        method: :get,
        url: @url,

        headers: {'Content-Type' => 'application/json',
                  "Authorization" => @auth})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)

    puts json

  end

end

APIBodega.get_skusWithStock('590baa77d6b4ec0004902cbf')