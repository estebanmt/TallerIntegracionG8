require 'net/sftp'
require 'net/ssh'
require 'json'
require 'active_support/core_ext/hash'
require 'rest_client'

class APIDistribuidores
  @OCDistribuidoresHASH = Array.new
  @API_URL_OC = "https://integracion-2017-dev.herokuapp.com/oc/"
  @GET_OC = 'obtener/'

  def self.OCDistribuidoresXML
    host = 'integra17dev.ing.puc.cl'
    user = 'grupo8'
    pass = 'h5GEam7Qe6M3nTD4'
    ocxml = []
    Net::SFTP.start(host, user, {:password => pass}) do |sftp|
        name = "/pedidos/"
        local = "../public/OCDistribuidoresXML"
        puts "descargando " + name
        sftp.download!(name,local,:recursive => true)
        puts "descargado"
    end
  end

  def self.OCDistribuidoresHASH
    files = Dir.glob("../public/OCDistribuidoresXML/*.xml")
    for f in files
      ochash = Hash.from_xml(File.read(f))
      @OCDistribuidoresHASH.push(ochash)
    end
  end

  def self.obtener_Ordenes
    self.OCDistribuidoresHASH
    for oc in @OCDistribuidoresHASH
      puts "-----------------------------------------------------------"
      puts id = oc["order"]["id"]
      puts getOrdenCompra(id)
    end
  end

  # Method that returns an order
  def self.getOrdenCompra(id)
    params = nil
    return get_url(@GET_OC + id, params)
  end

  def self.get_url(uri, params)
    #puts 'hello' + params

    @query_params = query_params(params)
    #puts 'hello' + @query_params


    if @query_params != nil
      @url = @API_URL_OC + uri + "?" + @query_params
    else
      @url = @API_URL_OC + uri
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

#APIDistribuidores.crearOCDistribuidores
APIDistribuidores.obtener_Ordenes
