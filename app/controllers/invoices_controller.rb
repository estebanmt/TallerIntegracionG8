require 'api_pago'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]



  # MEtodo que crea factura... PUT /
  def create
    response = ApiPago.crear_factura(params[:id_oc])
    render json: response
  end

  #METODO que obtiene una factura... GET /:id
  def get
    response = ApiPago.get_factura(params[:id_factura])
    render json: response
  end

  #METODO que acepta una factura... PUT /pay
  def accept
    response = ApiPago.pagar_factura(params[:id_factura])
    render json: response
  end

  #METODO que rechaza una factura... PUT /reject
  def reject
    response = ApiPago.rechazar_factura(params[:id_factura])
    render json: response
  end

  #Metodo que recibe notificacion de otro grupo que nos hizo una factura... PUT /invoices/:id_factura
  def notifyFactura
    response = ApiPago.recibir_notificacion_factura(params[:id_factura], params[:bank_account])
    render json: response
  end


  def pagar
    puts "."*1000
    @response = ApiPago.crear_boleta(params[:id], params[:monto].to_i)
  end

  def transaccionar
    puts "."*1000
    @response = ApiPago.transferir(params[:monto].to_i, params[:destino].to_s)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invoice_params
      params.require(:invoice).permit(:id_oc, :id_factura, :bank_account)
    end
end
