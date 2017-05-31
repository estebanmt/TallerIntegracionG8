class ApiPago

  @API_URL_FACTURAS = 'https://integracion-2017-prod.herokuapp.com/sii' ##Produccion

  def self.crear_boleta(id_cliente, monto)
    params = params = {'proveedor' => ENV['ID_GRUPO'],'cliente' => id_cliente, 'total' => monto}
    response = put_url('/boleta', params)
    #puts response
    return response
  end

  def self.put_url(uri, params)#, authorization)
    #puts params
    #@auth = 'INTEGRACION grupo8:'.concat(authorization)
    # puts @auth
    @url = @API_URL_FACTURAS + uri
    #puts @url
    #puts params
    @response= RestClient.put @url, params.to_json, :content_type => 'application/json'
    #, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

end
