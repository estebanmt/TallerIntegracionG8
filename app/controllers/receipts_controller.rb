class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :update, :destroy]

  # POST /boleta
  def create_from_invoice

  end


  # GET /receipts
  def index
    @receipts = Receipt.all

    render json: @receipts
  end

  # GET /receipts/1
  def show
    render json: @receipt
  end

  # POST /receipts
  def create
    @receipt = Receipt.new(receipt_params)

    if @receipt.save
      render json: @receipt, status: :created, location: @receipt
    else
      render json: @receipt.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /receipts/1
  def update
    if @receipt.update(receipt_params)
      render json: @receipt
    else
      render json: @receipt.errors, status: :unprocessable_entity
    end
  end

  # DELETE /receipts/1
  def destroy
    @receipt.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def receipt_params
      params.require(:receipt).permit(:supplier, :client, :amount)
    end
end
