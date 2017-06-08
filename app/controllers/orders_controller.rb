require 'rest-client'
require 'openssl'
require "base64"
require 'digest'
require 'api_orden_compra'
require 'api_b2b'
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
    ApiB2b.comprarProducto(params[:sku], params[:cantidad])
  end

  #METODOS API PROFESOR

    # POST /recepcionar/:id
    def receive
      ApiOrdenCompra.recepcionarOrdenCompra(params[:_id])
    end

    # POST /rechazar/:id
    def reject_order
      ApiOrdenCompra.rechazarOrdenCompra(params[:_id], params[:rechazo])
    end

    # DELETE /anular/:id
    def cancel_order
      ApiOrdenCompra.anularOrdenCompra(params[:_id], params[:anulacion])
    end

    # Metodo temporal para mock de GET /obtener/:id
    def show_order
      ApiOrdenCompra.getOrdenCompra(params[:id])
    end

    # PUT /crear
    def create_order
      ApiOrdenCompra.crearOrdenCompra(params[:cliente], params[:proveedor], params[:sku], params[:fechaEntrega],
                                      params[:cantidad], params[:precioUnitario], params[:canal],params[:notas])
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
