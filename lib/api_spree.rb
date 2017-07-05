require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'httparty'

class APISpree
  @SPREE_API_KEY = ENV["SPREE_API_KEY"]
  @API_URL_SPREE = ENV["API_URL_SPREE"]


  @SPREE_API_KEY = "a685e0757f4d0175ce1a17a924a330bfdcf8a939216171f0"
  @API_URL_SPREE = "http://localhost:4000/api/v1/"


  def initialize()

  end

  @products = [ [4, 'Aceite de Maravilla', 'Producto procesado', 8, 'Lts', 412, 200, 1, 2, 1.205],
                [6, 'Crema', 'Producto procesado', 8, 'Lts', 514, 30, 2, 2, 2.481],
                [19, 'Semola', 'Materia prima', 8, 'Kg', 116, 1420, 0, 1, 1.881],
                [20, 'Cacao', 'Materia prima', 8, 'Kg', 172, 60, 0, 5, 2.258],
                [23, 'Harina', 'Producto procesado', 8, 'Kg', 364, 300, 1, 6, 0.910],
                [26, 'Sal', 'Materia prima', 8, 'Kg', 99, 144, 0, 7, 3.059],
                [27, 'Levadura', 'Materia prima', 8, 'Kg', 232, 620, 0, 4, 1.566],
                [38, 'Semillas Maravilla', 'Materia prima', 8, 'Kg', 379, 30, 0, 3, 3.462],
                [42, 'Cereal Maiz', 'Producto procesado', 8, 'Kg', 812, 200, 3, 0, 2.743],
                [53, 'Pan Integral', 'Producto', 8, 'Kg', 934, 620, 5, 0, 2.400]]

  def self.create_all_object

    @products.each do |product|
      create_product(product[0].to_s, product[1].to_s, product[2].to_s, product[5].to_i)
    end
  end

  def self.create_product(sku, nombre, tipo, precio)
    params = {'product[sku]' => sku, 'product[name]' => nombre, 'product[price]' => precio, 'product[shipping_category_id]' => 1}
    return post_url('products', params)
  end

  def self.post_url(uri, params)
    @url = @API_URL_SPREE + uri
    body_params = query_params(params)
    puts @url
    puts body_params

    @response = RestClient::Request.new({
                                           method: :post,
                                           url: @url,
      user: 'someone',
      password: 'mybirthday',
      payload: params.to_json,
      headers: { :accept => :json, content_type: :json, :'X-Spree-Token' => @SPREE_API_KEY }
    }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, parse_json(response.to_str) ]
      when 200
        [ :success, parse_json(response.to_str) ]
      else
        fail "Invalid response #{response.to_str} received."
      end
    end




#
# begin
      #@response=RestClient.post @url, params.to_json, :content_type => :json, :accept => :json, :'X-Spree-Token' => @SPREE_API_KEY
      puts "response code " + @response.code.to_s
#    rescue Exception => e
#      puts e.message
#      puts e.backtrace.inspect
#    end
    json = JSON.parse(@response.body)
    puts json
  end

  def self.put_url(uri, params)
    puts params

    @url = @API_URL_SPREE + uri
    puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :"X-Spree-Token" => @SPREE_API_KEY
    json = JSON.parse(@response.body)
    return json
  end

  def self.query_params(params)
    if params != nil
      queryParams = "";
      params.each do |field, value|
        #queryParams.concat(field).concat("=").concat(value).concat("&");
        queryParams = queryParams + field.to_s + "=" + value.to_s + "&";
      end
      return queryParams
    else
      return nil;
    end
  end

end

APISpree.create_all_object