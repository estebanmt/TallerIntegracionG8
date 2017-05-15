require 'rest-client'
require 'openssl'
require "base64"
require 'digest'

class WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :update, :destroy]

  # GET /warehouses
  def index
    @warehouses = Warehouse.all

    render json: @warehouses
  end

  # GET /warehouses/1
  def show
    render json: @warehouse
  end

  # POST /warehouses
  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      render json: @warehouse, status: :created, location: @warehouse
    else
      render json: @warehouse.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /warehouses/1
  def update
    if @warehouse.update(warehouse_params)
      render json: @warehouse
    else
      render json: @warehouse.errors, status: :unprocessable_entity
    end
  end

  # DELETE /warehouses/1
  def destroy
    @warehouse.destroy
  end

  # GET almacenes
  def getAlmacenes
    @auth = 'INTEGRACION grupo8:' + doHashSHA1('GET')
    @response = RestClient::Request.execute(
      method: :get,
      url: 'https://integracion-2017-dev.herokuapp.com/bodega/almacenes',
      headers: {'Content-Type' =>'application/json',
                      "Authorization" => @auth})
    render json: @response
  end

  # GET skuWithStock
  def getSkusWithStock
    @url = 'https://integracion-2017-dev.herokuapp.com/bodega/skusWithStock?almacenId='+params[:id]
    @auth = 'INTEGRACION grupo8:'+doHashSHA1('GET'+params[:id])
    @response = RestClient::Request.execute(
      method: :get,
      url: @url,
      headers: {'Content-Type' =>'application/json',
                      "Authorization" => @auth})
    render json: @response
  end

  #GET stock
  def getStock
    @url = 'https://integracion-2017-dev.herokuapp.com/bodega/stock?almacenId='+params[:id]+'&sku='+params[:sku]
    @auth = 'INTEGRACION grupo8:'+doHashSHA1('GET'+params[:id]+params[:sku])
    @response = RestClient::Request.execute(
      method: :get,
      url: @url,
      headers: {'Content-Type' =>'application/json',
                      "Authorization" => @auth})
    render json: @response
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def warehouse_params
      params.require(:warehouse).permit(:id, :spaceUsed, :spaceTotal, :reception, :dispatch, :lung, :sku)
    end

    #Hash Sha1
    def doHashSHA1(authorization)
      @key = '2T02j&xwE#tQA#e'
        digest = OpenSSL::Digest.new('sha1')
        hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
        return Base64.encode64(hmac)
    end
end
