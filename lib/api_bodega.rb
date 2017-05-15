require 'rest_client'
require 'openssl'
require "base64"
require 'digest'

class APIBodega
  @key = '2T02j&xwE#tQA#e'
  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega/'
  @URI_GET_ALMACENES = 'almacenes'
  @GET_SKUS_WITH_STOCK = 'skusWithStock'
  @GET_STOCK = 'stock'

  @MOVE_STOCK = 'moveStock'

  def initialize()
  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
    return Base64.encode64(hmac)
  end

  def self.get_almacenes ()
    hmac = doHashSHA1('GET')
    return get_url(@URI_GET_ALMACENES, nil, hmac)
  end

  def self.get_skusWithStock(almacenId)
    hmac = doHashSHA1('GET'.concat(almacenId))
    params = {'almacenId' => almacenId}
    return get_url(@GET_SKUS_WITH_STOCK, params, hmac)
  end

  def self.get_stock(sku, almacenId)
    hmac = doHashSHA1('GET'.concat(almacenId + sku))
    params = {'almacenId' => almacenId, 'sku' => sku}
    return get_url(@GET_STOCK, params, hmac)
  end


  def self.mover_Stock(productoId, almacenId)
    hmac = doHashSHA1('POST'.concat(productoId).concat(almacenId))
    params = {'almacenId' => almacenId, 'productoId' => productoId}
    return post_url(@MOVE_STOCK, params, hmac)
  end

  def self.query_params(params)
    if params != nil
      queryParams = "";
      params.each do |field, value|
        queryParams.concat(field).concat("=").concat(value).concat("&");
        #queryParams = queryParams + field + "=" + value + "&";
      end
      return queryParams
    else
      return nil;
    end
  end


  def self.get_url(uri, params, authorization)
    puts params

    @query_params = query_params(params)
    puts @query_params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    puts @auth

    if @query_params != nil
      @url = @API_URL_DEV + uri + "?" + @query_params
    else
      @url = @API_URL_DEV + uri
    end
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

  def self.post_url(uri, params, authorization)
    puts params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    puts @auth

    @url = @API_URL_DEV + uri
    puts @url

    @response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
  end

end

#APIBodega.get_almacenes()
#APIBodega.get_skusWithStock('590baa77d6b4ec0004902cbf')
#APIBodega.get_stock('53', '590baa77d6b4ec0004902cbf')
#APIBodega.mover_Stock('590baa77d6b4ec0004902e63', '590baa77d6b4ec0004902cbe')
