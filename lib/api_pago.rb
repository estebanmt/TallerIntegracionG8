require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'uri'
require 'turbolinks/redirection'

class ApiPago

  @API_URL_FACTURAS = ENV["API_URL_FACTURAS"]
  @API_URL_PAGO = ENV["API_URL_PAGO"]
  @URL_PAY_PROXY = ENV["URL_PAY_PROXY"]


  def self.crear_boleta(id_cliente, monto)
    params = params = {'proveedor' => ENV["ID_GRUPO"],'cliente' => id_cliente, 'total' => monto}
    #puts params
    response = put_url('/boleta', params)
    Invoice.create(:client => response["cliente"], :gross_amount => response["bruto"],
    :iva => response["iva"], :total_amount => response["total"],
    :status => response["estado"], :order_id => response["oc"])
    boleta_id = response["_id"]
    puts Invoice.all
    #puts response
    return response
  end

  def self.get_boleta_id(id_cliente, monto)
    response = crear_boleta(id_cliente, monto)
    boleta_id = response["_id"]
    return boleta_id;
  end

  def self.pay(id_cliente, monto)

    boleta_id = get_boleta_id(id_cliente, monto)

    url_ok = URI.escape(@URL_PAY_PROXY + '/' + boleta_id + '/' + 'sucess')
    url_fail = URI.escape(@URL_PAY_PROXY + '/' + boleta_id + '/' + 'fail')

    @url = @API_URL_PAGO + '/pagoenlinea?' + 'callbackUrl=' + url_ok + '&' + 'cancelUrl' + url_fail + '&' + 'boletaId=' + boleta_id

    puts "url_pago #{@url}"

    params = {'amount' => monto, 'url' => @url, 'boletaId' => boleta_id}

    #response =  post_payproxy('', params)

    #response = redirect_to(@url)

    #@payproxy = Payproxy.create({"amount" => monto, "boleta_id" => boleta_id, "state" => 0})
    @payproxy = Payproxy.find_by_boleta_id(1)
    @payproxy.update_attribute(:state, 0)

    puts "iic3103 - Salindo"
  end

  def self.put_url(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @API_URL_FACTURAS + uri
    puts @url
    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'
    #, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

  def self.post_payproxy(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @URL_PAY_PROXY + uri
    puts "payproxy #{@url}"
    @response= RestClient.post @url, params.to_json, :content_type => 'application/json'
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


end
