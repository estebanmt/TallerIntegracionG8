require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require './api_bodega.rb'

class APIBanco
  @CUENTA_FABRICA =  "590baa00d6b4ec0004902460"
  @CUENTA_BANCO = "590baa00d6b4ec0004902470"
  @COSTO_SKU = ["4" => 412, "6"=> 514, "19"=> 116, "20"=> 172, "23"=>364,
     "26"=>99, "27"=> 232, "38"=> 379, "42"=> 812, "53"=> 934]

  @URL_PAGO_TRANSFERENCIA = "https://integracion-2017-dev.herokuapp.com/banco"
  @key_bodega = '2T02j&xwE#tQA#e'

  def self.pagar_fabricacion(sku, cantidad_unitaria)
    #puts @PRECIO_SKU[0][sku]
    total_a_pagar = @COSTO_SKU[0][sku].to_i*cantidad_unitaria.to_i
    #puts total_a_pagar
    return self.transferir(total_a_pagar)
    #puts comprobante_de_pago["_id"]
    #APIBodega.producir_Stock(sku, cantidad_unitaria, comprobante_de_pago["_id"])


  end

  def self.put_url(uri, params, authorization)
    #puts params

    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth

    @url = @URL_PAGO_TRANSFERENCIA + uri
    #puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json#, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    #puts json
  end

  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, @key_bodega, authorization)
    #puts hmac
    return Base64.encode64(hmac)
  end

  def self.transferir(monto)
    hmac = doHashSHA1('PUT')
    params = {'monto' => monto, 'origen' => @CUENTA_BANCO, 'destino' => @CUENTA_FABRICA}
    response = put_url("/trx", params, hmac)
    #return response["_id"]
    return response

  end


end
