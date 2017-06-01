require 'rest-client'
require 'openssl'
require "base64"
require 'digest'
require 'api_b2b'
require 'api_bodega'

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

  # GET /inicializar
  def initialize1
    ApiB2b.minMateriasPrimasProducto("53")
  end
  def initialize2
    ApiB2b.minMateriasPrimasProducto("26")
  end
  def initialize3
    ApiB2b.minMateriasPrimasProducto("38")
  end
  def initialize4
    ApiB2b.minMateriasPrimasProducto("7")
  end
  def initialize5
    ApiB2b.minMateriasPrimasProducto("23")
  end
  def initializePrimas
    APIBodega.minMateriasPrimasPropias
  end

  # GET /orden
  def order19
    APIBodega.producirStock19
  end
  def order20
    APIBodega.producirStock20
  end
  def order26
    APIBodega.producirStock26
  end
  def order27
    APIBodega.producirStock27
  end
  def order38
    APIBodega.producirStock38
  end

  def order_id
    #render json: params[:id]
    @response = APIBodega.producirStockSku(params[:id])
  end


def order_lotes
  render json: APIBodega.producir_lotes(params[:id], params[:lotes])
end

def mover_general_despacho
  render json: APIBodega.mover_General_Despacho(params[:sku], params[:cantidad].to_i)
end

def mover_despacho_general
  render json: APIBodega.mover_Despacho_General(params[:sku], params[:cantidad].to_i)
end


def mover_pulmon_general
  render json: APIBodega.mover_Pulmon_Recepcion_General(params[:sku], params[:cantidad].to_i)
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

  def vaciar_recepcion
    render json: APIBodega.vaciar_bodega_recepcion
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def warehouse_params
      params.require(:warehouse).permit(:id, :spaceUsed, :spaceTotal, :reception, :dispatch, :lung, :sku, :lotes)
    end

    #Hash Sha1
    def doHashSHA1(authorization)
      @key = '2T02j&xwE#tQA#e'
        digest = OpenSSL::Digest.new('sha1')
        hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
        return Base64.encode64(hmac)
    end
end
