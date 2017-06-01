require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'uri'

class ApiPago

  @API_URL_FACTURAS = ENV["API_URL_FACTURAS"]
  @API_URL_PAGO = ENV["URL_API_PAGO"]
  @URL_PAY_PROXY = ENV["URL_PAY_PROXY"]


  def self.crear_boleta(id_cliente, monto)
    params = params = {'proveedor' => '590baa00d6b4ec0004902469','cliente' => id_cliente, 'total' => monto}
    #puts params
    response = put_url('/boleta', params)
    puts response
    return response
  end

  def self.get_boleta_id(id_cliente, monto)

    response = crear_boleta(id_cliente, monto)

    boleta_id = response["_id"]

    return boleta_id;
  end

  def self.get_pago(boleta_id)
    url_ok = URI.encode(@URL_PAY_PROXY + '/' + boleta_id + '/' + 'sucess')
    url_fail = URI.encode(@URL_PAY_PROXY + '/' + boleta_id + '/' + 'fail')

    params = {'callbackUrl' => url_ok, 'cancelUrl' => url_fail, 'boletaId' => boleta_id}

    return get_url(@API_URL_PAGO, params, hmac)

  end

  def self.pay(id_cliente, monto)

    boleta_id = get_boleta_id(id_cliente, monto)
    response = get_pago(boleta_id)

    result = true;

    puts "iic3103 - Pay #{response}"

    return response
  end

  def self.put_url(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @API_URL_FACTURAS + uri
    #puts @url
    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'
    #, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
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
    #puts params

    @query_params = query_params(params)
    puts @query_params

    @auth = 'INTEGRACION grupo8:'.concat(authorization)

    if @query_params != nil
      @url = @API_URL_BODEGA + uri + "?" + @query_params
    else
      @url = @API_URL_BODEGA + uri
    end

    @response = RestClient::Request.execute(
        method: :get,
        url: @url,
        headers: {'Content-Type' => 'application/json',
                  "Authorization" => @auth})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
    return json

  end

end
