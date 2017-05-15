require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'security'
require 'json'

class ApiOrdenCompra
  @key = '0pPfDeRT'
  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/oc/'

  @GET_OC = 'obtener/'
  @CREAR_OC = 'crear/'

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')

    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
    return Base64.encode64(hmac)
  end

  def self.getOrdenCompra(id)
    hmac = doHashSHA1('GET'.concat(id))
    puts 'hmac: ' + hmac
    params = nil
    return get_url(@GET_OC + id, params, hmac)
    #return hmac
  end


  def self.crearOrdenCompra(cliente, proveedor, sku, fechaEntrega, cantidad, precioUnitario, canal, notas)
    puts 'hmac: ' + hmac
    params = {'cliente' => cliente, 'proveedor' => proveedor, 'sku' => sku, 'fechaEntrega' => fechaEntrega,
                  'cantidad' => cantidad, 'precioUnitario' => precioUnitario, 'canal' => canal, 'notas' => notas }
    return post_url(@CREAR_OC, params, hmac)
    #return hmac
  end

  def self.recepcionarOrdenCompra(id)
    hmac = doHashSHA1('POST'.concat(id))
    params = nil
    return get_url(@GET_OC + id, params, hmac)
  end

  def self.get_url(uri, params, authorization)
    #puts 'hello' + params

    @query_params = query_params(params)
    #puts 'hello' + @query_params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)
    #puts @auth

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

    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
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
end

#ApiOrdenCompra.getOrdenCompra('5919fb02ea37b2000403c2d5')