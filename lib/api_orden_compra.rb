require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'

class ApiOrdenCompra
  @API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/oc/'

  @GET_OC = 'obtener/'
  @RECEIVE_OC = 'recepcionar/'
  @CREAR_OC = 'crear/'
  @ANULAR_OC = 'anular/'
  @RECHAZAR_OC = 'rechazar/'





  # Method that receives order notification from other group (invoked by /purchase_orders/:id)
  def self.notificarPedido(id)
    return self.getOrdenCompra(id)

    # revisar que o/c existe
    # revisar que estado sea "creada"
    # evaluar si se acepta o no
    # aceptar o rechazar
    # indicar a otro grupo

  end

  # Method that changes order status to "rechazada"
  def self.rechazarOrdenCompra(id, rechazo)
    params = {'_id' => id, 'rechazo' => rechazo}
    return post_url(@RECHAZAR_OC + id, params)
    #return hmac
  end

  # Method that changes order status to "anulada"
  def self.anularOrdenCompra(id, anulacion)
    params = {'_id' => id, 'anulacion' => anulacion}
    return post_url(@ANULAR_OC + id, params)
    #return hmac
  end

  # Method that returns an order
  def self.getOrdenCompra(id)
    params = nil
    return get_url(@GET_OC + id, params)
  end

  # Method that changes order status to "aceptada"
  def self.recepcionarOrdenCompra(id)
    params = { '_id' => id }
    return post_url(@RECEIVE_OC + id, params)
  end

  # Method that creates order in external API
  def self.crearOrdenCompra(cliente, proveedor, sku, fechaEntrega, cantidad, precioUnitario, canal, notas)
    params = {'cliente' => cliente, 'proveedor' => proveedor, 'sku' => sku, 'fechaEntrega' => fechaEntrega,
                  'cantidad' => cantidad, 'precioUnitario' => precioUnitario, 'canal' => canal, 'notas' => notas }
    return put_url(@CREAR_OC, params)
  end

  def self.get_url(uri, params)
    #puts 'hello' + params

    @query_params = query_params(params)
    #puts 'hello' + @query_params


    if @query_params != nil
      @url = @API_URL_DEV + uri + "?" + @query_params
    else
      @url = @API_URL_DEV + uri
    end
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

  def self.put_url(uri, params)
    puts params


    @url = @API_URL_DEV + uri
    puts @url

    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    puts json
    return json
  end

  def self.post_url(uri, params)
    puts params


    @url = @API_URL_DEV + uri
    puts @url
    puts params

    @response=RestClient.post @url, params.to_json, :content_type => :json
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