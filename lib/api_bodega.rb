class APIBodega

  require 'rest_client'

  API_URL_DEV = 'https://integracion-2017-dev.herokuapp.com/bodega'

  GET_ALMACENES = 'almacenes'

  def unique_url(uri, params)
    response = RestClient.get(API_URL + uri, params)

    # TODO more error checking (500 error, etc)
    json = JSON.parse(response.body)
    json['url']
  end

end