require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'uri'
require 'turbolinks/redirection'
require_relative 'api_orden_compra'

class ApiPago

  @API_URL_FACTURAS = ENV["API_URL_FACTURAS"]
  @API_URL_PAGO = ENV["API_URL_PAGO"]
  @URL_PAY_PROXY = ENV["URL_PAY_PROXY"]
  @CUENTA_BANCO = ENV["CUENTA_BANCO"]
  @URL_PAGO_TRANSFERENCIA = ENV["URL_PAGO_TRANSFERENCIA"]

  #ids de los grupos
  @ID_GRUPO = ENV["ID_GRUPO"]
  @ID_GRUPO1 = ENV["ID_GRUPO1"]
  @ID_GRUPO2 = ENV["ID_GRUPO2"]
  @ID_GRUPO3 = ENV["ID_GRUPO3"]
  @ID_GRUPO4 = ENV["ID_GRUPO4"]
  @ID_GRUPO5 = ENV["ID_GRUPO5"]
  @ID_GRUPO6 = ENV["ID_GRUPO6"]
  @ID_GRUPO7 = ENV["ID_GRUPO7"]

  # urls de los grupos
  @URL_GRUPO1 = ENV["URL_GRUPO1"]
  @URL_GRUPO2 = ENV["URL_GRUPO2"]
  @URL_GRUPO3 = ENV["URL_GRUPO3"]
  @URL_GRUPO4 = ENV["URL_GRUPO4"]
  @URL_GRUPO5 = ENV["URL_GRUPO5"]
  @URL_GRUPO6 = ENV["URL_GRUPO6"]
  @URL_GRUPO7 = ENV["URL_GRUPO7"]

  def self.crear_boleta(id_cliente, monto)
    params = {'proveedor' => ENV["ID_GRUPO"],'cliente' => id_cliente, 'total' => monto}
    #puts params
    response = put_url('boleta', params)
    Invoice.create(:client => response["cliente"], :gross_amount => response["bruto"],
    :iva => response["iva"], :total_amount => response["total"],
    :status => response["estado"], :order_id => response["oc"])
    boleta_id = response["_id"]
    puts Invoice.all
    #puts response
    return response
  end

  #MEtodo para get una factura    .... /factura/:id_factura
  def self.get_factura(id_factura)
    response = get_url(id_factura)
    puts response
    return response[0]
  end

  #MEtodo que acepta factura a la api profesor... /factura/aceptar/:id_factura
  def self.aceptar_factura (id_factura)
    params = {'id' => id_factura}
    response = post_url('pay/', params)
    puts response
    return response
  end

  #MEtodo que rechaza factura a la api profesor  ... /factura/rechazar/:id_factura
  def self.rechazar_factura (id_factura)
    params = {'id' => id_factura}
    response = post_url('reject/', params)
    puts response
    return response
  end

  #Metodo que crea factura en la api profesor... /factura/crear/:id_oc
  def self.crear_factura (id_oc)
    params = {'oc' => id_oc}
    response = put_url('', params)
    puts response["oc"]
    return response
  end

  # Envia notificacion a otro grupo de que se creo una factura para su pedido
  def self.enviar_notificacion_fatura(id_factura, id_otro_grupo)
    urlOtroGrupo = get_url_from_grupo_id(id_otro_grupo)
    @url = urlOtroGrupo.to_s + "/invoices/" + id_factura.to_s
    params = {'bank_account' => @CUENTA_BANCO}
    puts @url
    begin
      @response= RestClient.put @url, params.to_json, :content_type => 'application/json'
      puts @response
      puts "notificacion a otro grupo ok"
    rescue
      puts "fallo request a otro grupo"
    end


  end

  # Obtiene la url de un grupo a partir de su id
  def self.get_url_from_grupo_id(idOtroGrupo)
    case idOtroGrupo
      when @ID_GRUPO1
        return @URL_GRUPO1
      when @ID_GRUPO2
        return @URL_GRUPO2
      when @ID_GRUPO3
        return @URL_GRUPO3
      when @ID_GRUPO4
        return @URL_GRUPO4
      when @ID_GRUPO5
        return @URL_GRUPO6
      when @ID_GRUPO7
        return @URL_GRUPO8
    end
  end

  #MEtodo que recibe notificacion de otro grupo, q nos hizo una factura.
  def self.recibir_notificacion_factura(id_factura, bank_account)

    begin
      factura = get_factura(id_factura)
    rescue => ex
      return {"error": ex.message}
    end

    puts factura
    puts factura["cliente"]
    puts @ID_GRUPO

    if factura["cliente"] != @ID_GRUPO
      return {"error": "Factura no corresponde a cliente."}
    end

    if factura["proveedor"] != @ID_GRUPO1 && factura["proveedor"] != @ID_GRUPO2 && factura["proveedor"] != @ID_GRUPO3 && factura["proveedor"] != @ID_GRUPO4 &&
        factura["proveedor"] != @ID_GRUPO5 && factura["proveedor"] != @ID_GRUPO6 && factura["proveedor"] != @ID_GRUPO7
        return {"error": "Factura no corresponde a ningun proveedor."}
    end

    if factura["estado"] != "pendiente"
      return {"error": "Factura ya procesada."}
    end

    begin
      oc = ApiOrdenCompra.getOrdenCompra(factura["oc"])
    rescue => ex
      return {"error": "Error en oc: " + ex.message}
    end

    if oc["cliente"] != @ID_GRUPO
      return {"error": "OC no corresponde a cliente."}
    end


    if oc["estado"] == "aceptada"
      begin
        response = transferir(factura["total"], bank_account)
      rescue => ex
        return {error:"Problemas al transferir. Dato bancario incorrecto."}
      end
      aceptar_factura(factura["_id"])
      return {"accept":"true"}
    else
      return {"error":"OC no esta aceptada."}
    end

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

    response = redirect_to(@url)

    @payproxy = Payproxy.create({"amount" => monto, "boleta_id" => boleta_id, "state" => 0})
    @payproxy = Payproxy.find_by_boleta_id(1)
    @payproxy.update_attribute(:state, 0)

    response = get_pago(boleta_id)

    result = true;

    puts "iic3103 - Pay #{response}"

    return response
  end

  def self.get_url(id_factura)

    @url = @API_URL_FACTURAS + id_factura
    puts @url

    @response = RestClient::Request.execute(
        method: :get,
        url: @url,
        headers: {'Content-Type' => 'application/json'})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
    return json
  end

  def self.put_url(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @API_URL_FACTURAS + uri
    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'
    #, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

  def self.post_url(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @API_URL_FACTURAS + uri
    @response= RestClient.post @url, params.to_json, :content_type => 'application/json'
    #, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
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

  def self.transferir(monto, destino)
    puts "-"*100
    puts destino
    params = {'monto' => monto.to_s, 'origen' => @CUENTA_BANCO, 'destino' => destino.to_s}
    response = put_url_banco("/trx", params)
    puts response
    return response
  end

  def self.put_url_banco(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @URL_PAGO_TRANSFERENCIA + uri
    puts params
    puts @url
    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end



end
