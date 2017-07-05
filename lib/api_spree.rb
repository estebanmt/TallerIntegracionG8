require_relative 'api_bodega'
require 'rest_client'
require 'openssl'
require "base64"
require 'digest'
require 'json'
require 'httparty'
require 'cgi'


class APISpree
  @SPREE_API_KEY = ENV["SPREE_API_KEY"]
  @API_URL_SPREE = ENV["API_URL_SPREE"]
  @BODEGA_GENERAL =  ENV["BODEGA_GENERAL"]


 # @SPREE_API_KEY = "a685e0757f4d0175ce1a17a924a330bfdcf8a939216171f0"
 # @API_URL_SPREE = "http://localhost:4000/api/v1/"
 # @BODEGA_GENERAL =  "590baa77d6b4ec0004902cbf"


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


  def self.refresh_stock
    json = APIBodega.get_skusWithStock(@BODEGA_GENERAL)
    puts  "skus con stock #{json}"

    @products.each do |product|

      stock_item =  get_stock_item(product[0].to_s)
      if (stock_item != nil)
        add_stock(stock_item["id"], 100)
      else
        puts "product invalid con sku #{product[0].to_s}"
      end


    end
  end

  def self.create_product(sku, nombre, tipo, precio)
    params = {'product[sku]' => sku, 'product[name]' => nombre, 'product[price]' => precio, 'product[shipping_category_id]' => 1}
    #params = {'sku' => sku, 'name' => nombre, 'price' => precio, 'shipping_category_id' => 1}
    return post_url('products', params)
  end




  def self.post_url(uri, params)
    @url = @API_URL_SPREE + uri
    #query_params = CGI::escape(query_params(params))
    query_params = query_params(params)
    puts @url
    puts query_params
    puts params.to_json

    url_param = @url + '?' + query_params

    @response = RestClient::Request.new({
      method: :post,
      url: url_param,
      user: 'someone',
      password: 'mybirthday',
      headers: { :accept => :json, content_type: :json, :'X-Spree-Token' => @SPREE_API_KEY }
    }).execute do |response, request, result|
      case response.code
      when 400
        [ :error, response.to_str.to_json ]
      when 200
        [ :success, response.to_str.to_json ]
      when 201
        [ :success, response.to_str.to_json ]
      else
        puts  "Invalid response #{response.to_str} received."
      end
    end

  end


  def self.add_stock(stock_item_id, quantity)
    @url = @API_URL_SPREE + 'stock_locations/1/stock_movements'

    body = '{
      "stock_movement": {
        "quantity":"' + quantity.to_s + '",
        "stock_item_id":"' + stock_item_id.to_s + '",
        "action": "received"
      }
    }'

    puts @url

    @response = RestClient::Request.new({
                                            method: :post,
                                            url: @url,
                                            user: 'someone',
                                            password: 'mybirthday',
                                            payload: body,
                                            headers: { :accept => :json, content_type: :json, :'X-Spree-Token' => @SPREE_API_KEY }
                                        }).execute do |response, request, result|
      case response.code
        when 400
          [ :error, response.to_str.to_json ]
        when 200
          [ :success, response.to_str.to_json ]
        when 201
          [ :success, response.to_str.to_json ]
        else
          fail "Invalid response #{response.to_str} received."
      end
    end

    puts @response

  end

  def self.get_stock_item(sku)
    params = {'q[sku_cont]' => sku}
    variants = get('variants', params)
    if (variants["count"] > 0)
      stock_items = variants["variants"][0]["stock_items"]
      stock_items.each do |item|
        if item["available"]
          return item
        end
      end
    end
  end

  def self.get(uri, params)
    @url = @API_URL_SPREE + uri
    #query_params = CGI::escape(query_params(params))
    query_params = query_params(params)
    puts @url
    puts query_params
    puts params.to_json

    url_param = @url + '?' + query_params

    @response = RestClient::Request.execute(
        method: :get,
        url: url_param,
        headers: { :accept => :json, content_type: :json, :'X-Spree-Token' => @SPREE_API_KEY }
    )

     json1 = JSON.parse(@response)

    puts json1

    return json1
  end

  def self.test
    client = Spree::API::Client.new(@API_URL_SPREE, @SPREE_API_KEY)
    products = client.products

    puts products
  end

  def self.update_product(sku, cantidad)
    params = {'product[sku]' => sku, 'product[name]' => nombre, 'product[price]' => precio, 'product[shipping_category_id]' => 1}
    #params = {'sku' => sku, 'name' => nombre, 'price' => precio, 'shipping_category_id' => 1}
    return post_url('products', params)
  end

  def self.put_url(uri, params)
    @url = @API_URL_SPREE + uri
    #query_params = CGI::escape(query_params(params))
    query_params = query_params(params)
    puts @url
    puts query_params
    puts params.to_json

    url_param = @url + '?' + query_params

    @response = RestClient::Request.new({
                                            method: :post,
                                            url: url_param,
                                            user: 'someone',
                                            password: 'mybirthday',
                                            headers: { :accept => :json, content_type: :json, :'X-Spree-Token' => @SPREE_API_KEY }
                                        }).execute do |response, request, result|
      case response.code
        when 400
          [ :error, response.to_str.to_json ]
        when 200
          [ :success, response.to_str.to_json ]
        when 201
          [ :success, response.to_str.to_json ]
        else
          fail "Invalid response #{response.to_str} received."
      end
    end

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

#APISpree.refresh_stock