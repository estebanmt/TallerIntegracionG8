class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :update, :destroy]

  # PUT /invoices
  # PUT /invoices/:id
  def receive

  end

  # POST /invoices/:id
  # POST /invoices/:id/accepted
  def accept

  end

  # DELETE /invoices/:id
  # PATCH /invoices/:id/rejected
  def reject

  end

  # PATCH /invoices/:id/delivered
  def delivered

  end

  # PATCH /invoices/:id/paid
  def paid

  end

  # GET /invoices
  def index
    @invoices = Invoice.all

    render json: @invoices
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
