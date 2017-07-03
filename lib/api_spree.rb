require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'httparty'

class APISpree
  @SPREE_API_KEY = ENV["SPREE_API_KEY"]
  @API_URL_SPREE = ENV["API_URL_SPREE"]

  @ingredients = [ [4, 'Aceite de Maravilla', 'Lts', 38, 'Semillas Maravilla', 190, 'Kg'],
              [6, 'Crema', 'Lts', 49, 'Leche Descremada', 100, 'Lts'],
              [6, 'Crema', 'Lts', 7, 'Leche', 300, 'Lts'],
              [23, 'Harina', 'Kg', 8, 'Trigo', 309, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 25, 'Azucar', 67, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 20, 'Cacao', 71, 'Kg'],
              [42, 'Cereal Maiz', 'Kg', 3, 'Maiz', 69, 'Kg'],
              [53, 'Pan Integral', 'Kg', 52, 'Harina Integral', 500, 'Kg'],
              [53, 'Pan Integral', 'Kg', 26, 'Sal', 63, 'Kg'],
              [53, 'Pan Integral', 'Kg', 7, 'Leche', 651, 'Lts'],
              [53, 'Pan Integral', 'Kg', 23, 'Harina', 15, 'Kg'],
              [53, 'Pan Integral', 'Kg', 38, 'Semillas Maravilla', 250,'Kg']
  ]

  @LOTE_SKU = ["4" => 200, "6"=> 30, "19"=> 1420, "20"=> 60, "23"=>300,
     "26"=>144, "27"=> 620, "38"=> 30, "42"=> 200, "53"=> 620]


  ## Create
  curl -i -X POST -H "X-Spree-Token: 1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f" -d "product[name]=Prod1&product[price]=1000&product[shipping_category_id]=1" \
http://localhost:4000/api/v1/products

  @URI_GET_PRODUCTS = 'products'


  def initialize()
  end

  @COSTO_SKU = ["4" => 412, "6"=> 514, "19"=> 116, "20"=> 172, "23"=>364,
     "26"=>99, "27"=> 232, "38"=> 379, "42"=> 812, "53"=> 934]

  @URL_PAGO_TRANSFERENCIA = ENV["URL_PAGO_TRANSFERENCIA"]


  def self.update_sku()
    params = {'monto' => monto, 'origen' => @CUENTA_BANCO, 'destino' => @CUENTA_FABRICA}
    response = put_url_banco("/trx", params, )
    #return response["_id"]
    return response
  end

  def self.put_url_spree(uri, params)
    @url = @API_URL_SPREE + uri
    #puts params
    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json#, :Authorization => 'INTEGRACION grupo8:'.concat(authorization)
    json = JSON.parse(@response.body)
    return json
  end

  def self.create_sku(productoId, almacenId)
    params = {'product[name]' => almacenId, 'product[price]' => productoId, 'product[shipping_category_id]' => 1}

    return post_url(@API_URL_SPREE, params)
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

  def self.post_url(uri, params)
    @url = @API_URL_SPREE + uri
    begin
      @response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :X-Spree-Token => @SPREE_API_KEY
      puts "response code " + @response.code.to_s
    rescue
      puts "--------------------INTENTANDO NUEVAMENTE--------------------------"
      retry
    end
    json = JSON.parse(@response.body)
    puts json
  end

  def self.put_url(uri, params, authorization)
    #puts params

    @url = @API_URL_SPREE + uri
    #puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :X-Spree-Token => @SPREE_API_KEY
    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    return json
  end

  def self.delete_url(uri, params, authorization)
    @url = @API_URL_SPREE + uri

    @response = HTTParty.delete(@url, {:headers => {'Content-Type' => 'application/json', :X-Spree-Token => @SPREE_API_KEY},
                                       :body => params.to_json})

    # TODO more error checking (500 error, etc)
    json = JSON.parse(@response.body)
    #puts json
    return json

  end


end

