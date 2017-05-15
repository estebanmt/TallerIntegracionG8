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



  # PUT /purchase_orders
  # PUT /purchase_orders/:id
  # POST /recepcionar/:id
  def receive
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
    "status": "Recibido",
    "rejection_motive": "",
    "cancellation_motive": "",
    "notes": "Urgente",
    "invoice_id": "999",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
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
  def reject
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
    "status": "Rechazado",
    "rejection_motive": "No hay stock",
    "cancellation_motive": "",
    "notes": "Urgente",
    "invoice_id": "999",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # DELETE /anular/:id
  def cancel
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
    "status": "Anulado",
    "rejection_motive": "",
    "cancellation_motive": "Producto no existe",
    "notes": "Urgente",
    "invoice_id": "999",
    "created_at": "2017-04-26T22:40:17.326Z"
}]'
  end

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # Metodo temporal para mock de GET /obtener/:id
  def show_order
    ApiOrdenCompra.getOrdenCompra(params[:id])
  end


  # PUT /crear
  def create_order
    ApiOrdenCompra.crearOrdenCompra(params[:cliente], params[:proveedor], params[:sku], params[:fecha_entrega],
                                    params[:cantidad], params[:precio_unitario], params[:canal],params[:notas])
    # @order = Order.new(order_params)
    #
    # if @order.save
    #   render json: @order, status: :created, location: @order
    # else
    #   render json: @order.errors, status: :unprocessable_entity
    # end
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
      params.require(:order).permit(:order_id, :canal, :proveedor, :cliente, :sku, :cantidad, :cantidad_despachada,
                                    :precio_unitario, :fecha_entrega, :estado, :motivo_rechazo, :motivo_anulacion,
                                    :notas, :id_factura)
    end

    # def order_params
    #   params.require(:order).permit(:canal, :cantidad, :proveedor, :cliente, :sku, :fecha_entrega, :notas)
    # end
end
