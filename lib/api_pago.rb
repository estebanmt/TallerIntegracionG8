class ApiPago

  @API_URL_FACTURAS = 'https://integracion-2017-dev.herokuapp.com/sii' ##Produccion

  def self.crear_boleta(id_cliente, monto)
    params = params = {'proveedor' => '590baa00d6b4ec0004902469','cliente' => id_cliente, 'total' => monto}
    #puts params
    response = put_url('/boleta', params)
    puts response
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

end
