class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # PUT /purchase_orders
  # PUT /purchase_orders/:id
  # POST /recepcionar/:id
  def receive

  end

  # POST /purchase_orders/:id
  # PATCH /purchase_orders/accepted
  def accept

  end

  # POST /purchase_orders/:id
  # PATCH /purchase_orders/:id/rejected
  # POST /rechazar/:id
  def reject

  end

  # DELETE /anular/:id
  def cancel

  end

  # GET /orders
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/:id
  # GET /obtener/:id
  def show
    render json: @order
  end

  # PUT /crear
  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
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
