class Spree::MyPaysController < ApplicationController
  before_action :set_spree_my_pay, only: [:show, :edit, :update, :destroy]

  # GET /spree/my_pays
  # GET /spree/my_pays.json
  def index
    @spree_my_pays = Spree::MyPay.all
  end

  # GET /spree/my_pays/1
  # GET /spree/my_pays/1.json
  def show
  end

  # GET /spree/my_pays/new
  def new
    @spree_my_pay = Spree::MyPay.new
  end

  # GET /spree/my_pays/1/edit
  def edit
  end

  # POST /spree/my_pays
  # POST /spree/my_pays.json
  def create
    @spree_my_pay = Spree::MyPay.new(spree_my_pay_params)

    respond_to do |format|
      if @spree_my_pay.save
        format.html { redirect_to @spree_my_pay, notice: 'My pay was successfully created.' }
        format.json { render :show, status: :created, location: @spree_my_pay }
      else
        format.html { render :new }
        format.json { render json: @spree_my_pay.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spree/my_pays/1
  # PATCH/PUT /spree/my_pays/1.json
  def update
    respond_to do |format|
      if @spree_my_pay.update(spree_my_pay_params)
        format.html { redirect_to @spree_my_pay, notice: 'My pay was successfully updated.' }
        format.json { render :show, status: :ok, location: @spree_my_pay }
      else
        format.html { render :edit }
        format.json { render json: @spree_my_pay.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spree/my_pays/1
  # DELETE /spree/my_pays/1.json
  def destroy
    @spree_my_pay.destroy
    respond_to do |format|
      format.html { redirect_to spree_my_pays_url, notice: 'My pay was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spree_my_pay
      @spree_my_pay = Spree::MyPay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spree_my_pay_params
      params.require(:spree_my_pay).permit(:live, :event_code, :psp_reference, :original_reference, :merchant_reference, :merchant_account_code, :event_date, :success, :payment_method, :operations, :reason, :currency, :value, :processed)
    end
end
