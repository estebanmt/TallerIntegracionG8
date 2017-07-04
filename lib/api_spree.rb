require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'httparty'

class APISpree
  @SPREE_API_KEY = ENV["SPREE_API_KEY"]
  @API_URL_SPREE = ENV["API_URL_SPREE"]


  def initialize()
    create_all_object
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

  def self.create_all_object()
    @products.each do |product|
      create_sku(product[1], product[2], product[3], product[6])
    end
  end

  def self.create_product(sku, nombre, tipo, precio)
    params = {'product[sku]' => sku, 'product[name]' => nombre, 'product[price]' => precio, 'product[shipping_category_id]' => 1}
    return post_url('products', params)
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

  def self.put_url(uri, params)
    puts params

    @url = @API_URL_SPREE + uri
    puts @url

    @response=RestClient.put @url, params.to_json, :content_type => :json, :accept => :json, :X-Spree-Token => @SPREE_API_KEY
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

