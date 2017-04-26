class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]

  # PUT /invoices
  # PUT /invoices/:id
  def receive
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Recibida",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # POST /invoices/:id
  # POST /invoices/:id/accepted
  def accept
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Aceptada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # DELETE /invoices/:id
  # PATCH /invoices/:id/rejected
  def reject
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Rechazada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # PATCH /invoices/:id/delivered
  def delivered
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Entregada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # PATCH /invoices/:id/paid
  def paid
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Pagada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # Metodo temporal para mock de invoice
  def show_invoice
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Creada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # PUT /
  def generate
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Creada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # POST /cancel
  def cancel
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "status": "Cancelada",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # GET /invoices
  def index
    # @invoices = Invoice.all
    #
    # render json: @invoices
    render json: '[{
    "invoice_id": "123",
    "amount": 100000,
    "sender": "empresa X",
    "receiver": "empresa Y",
    "created_at": "2017-04-26T22:40:17.326Z",
    "expires_at": "2017-05-26T22:40:17.326Z"
}]'
  end

  # GET /invoices/1
  def show
    render json: @invoice
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      render json: @invoice, status: :created, location: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invoice_params
      params.fetch(:invoice, {})
    end
end
