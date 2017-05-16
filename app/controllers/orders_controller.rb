require 'rest-client'
require 'openssl'
require "base64"
require 'digest'
require 'api_orden_compra'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]
  #before_action :render_message, unless: :check_header

  def check_header
    !request.env["HTTP_X_ACCESS_TOKEN"].nil?
  end

  def render_message
    render json: '[{"Error": "autentificacion incorrecta"}]', :status => 401
  end


  # PUT /purchase_orders/:id
  def receive_order

  end

  # POST /recepcionar/:id
  def receive
     ApiOrdenCompra.recepcionarOrdenCompra(params[:_id])
  end

  # POST /purchase_orders/:id
  # PATCH /purchase_orders/accepted
  def accept
    render json: '[{
    "order_id": "423",
    "channel": "b2b",
    "supplier": "proveedor X",
    "client": "cliente Y",
    "sku": "jkl567",
    "amount": 100,
    "amount_dispatched": 0,
    "unit_price": 5,
    "delivery_date": null,
    "status": "Aceptado",
    "rejection_motive": "No hay stock",
    "cancellation_motive": "",
    "notes": "Urgente",
    "invoice_id": "999",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # POST /purchase_orders/:id
  # PATCH /purchase_orders/:id/rejected


  # POST /rechazar/:id
  def reject_order
    ApiOrdenCompra.rechazarOrdenCompra(params[:_id], params[:rechazo])
  end

  # DELETE /anular/:id
  def cancel_order
    ApiOrdenCompra.anularOrdenCompra(params[:_id], params[:anulacion])
  end

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # Metodo temporal para mock de GET /obtener/:id
  def show_order
    ApiOrdenCompra.getOrdenCompra(params[:_id])
  end

  # PUT /crear
  def create_order
    ApiOrdenCompra.crearOrdenCompra(params[:cliente], params[:proveedor], params[:sku], params[:fechaEntrega],
                                    params[:cantidad], params[:precioUnitario], params[:canal],params[:notas])
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
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

    # def order_params
    #   params.require(:order).permit(:canal, :cantidad, :proveedor, :cliente, :sku, :fecha_entrega, :notas)
    # end
end
