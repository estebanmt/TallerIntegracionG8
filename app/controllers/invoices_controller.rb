require 'api_pago'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]



  # MEtodo que crea factura... PUT /
  def create
    ApiPago.crear_factura(params[:id_oc])
  end

  #METODO que obtiene una factura... GET /:id
  def get
    ApiPago.get_factura(params[:id_factura])
  end

  #METODO que acepta una factura... PUT /pay
  def accept
    ApiPago.pagar_factura(params[:id_factura])
  end

  #METODO que rechaza una factura... PUT /reject
  def reject
    ApiPago.rechazar_factura(params[:id_factura])
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
  end

  def pagar
    puts "."*1000
    @response = ApiPago.crear_boleta(params[:id], params[:monto].to_i)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invoice_params
      params.require(:invoice).permit(:id_oc, :id_factura)
    end
end
