require 'rest-client'
require 'openssl'
require "base64"
require 'digest'
require 'api_orden_compra'
require 'api_b2b'
require 'api_distribuidores'
require 'json'

class OrdersController < ApiController
  before_action :set_order, only: [:show, :update, :destroy]
  #before_action :render_message, unless: :check_header

  def check_header
    !request.env["HTTP_X_ACCESS_TOKEN"].nil?
  end

  def render_message
    render json: '[{"Error": "autentificacion incorrecta"}]', :status => 401
  end


  #METODOS OTROS GRUPOS

  # PUT /purchase_orders/:id
  # A clientes (otros grupos)
  def notify
    @body = JSON.parse request.body.read
    idBodegaCliente = @body[0]["id_store_reception"]
    # json = ApiOrdenCompra.getOrdenCompra(params[:_id])[0]
    ApiB2b.revisarOrdenCompra(params[:id], idBodegaCliente)
  end

  def test
    @body = JSON.parse request.body.read
    puts @body[0]["test"]
    puts 'hello'*100
    render json: @body
  end

  # POST /purchase_orders/:id  ..... realizar pedido a cliente
  #def enviarOrdenCliente end
  # PATCH /purchase_orders/accepted
  #def aceptarOrdenCliente end
  # PATCH /purchase_orders/:id/rejected
  #  def rechazarOrdenCliente end


  #METODO que envia OC a todos los grupos para comprar un sku especifico, con cantidad.

  def comprar_producto
    response = ApiB2b.comprarProducto(params[:sku], params[:cantidad])
    render json: response
  end

  #METODOS API PROFESOR

    # POST /recepcionar/:id
    def receive_order
      response = ApiOrdenCompra.recepcionarOrdenCompra(params[:_id])
      render json: response
    end

    # POST /rechazar/:id
    def reject_order
      response = ApiOrdenCompra.rechazarOrdenCompra(params[:_id], params[:rechazo])
      render json: response
    end

    # DELETE /anular/:id
    def cancel_order
      response = ApiOrdenCompra.anularOrdenCompra(params[:_id], params[:anulacion])
      render json: response
    end

    # Metodo temporal para mock de GET /obtener/:id
    def show_order
      response = ApiOrdenCompra.getOrdenCompra(params[:id])
      render json: response
    end

    # PUT /crear
    def create_order
      response = ApiOrdenCompra.crearOrdenCompra(params[:cliente], params[:proveedor], params[:sku], params[:fechaEntrega],
                                      params[:cantidad], params[:precioUnitario], params[:canal],params[:notas])
      render json: response
    end

    def distribuidores_dev
      APIDistribuidores.revisar_Ordenes_DEV
    end

    def distribuidores_prod
      APIDistribuidores.revisar_Ordenes_PROD
    end

    def estado_distribuidores_dev
      APIDistribuidores.estado_Ordenes_DEV
    end

    def estado_distribuidores_prod
      APIDistribuidores.estado_Ordenes_PROD
    end

    def auto_distribuidores_dev
      APIDistribuidores.auto_Revisar_Ordenes_DEV
    end

    def auto_distribuidores_prod
      APIDistribuidores.auto_Revisar_Ordenes_PROD
    end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:_id, :canal, :proveedor, :cliente, :sku, :cantidad, :cantidadDespachada,
                                    :precioUnitario, :fechaEntrega, :estado, :rechazo, :anulacion,
                                    :notas, :id_factura)
    end


end
