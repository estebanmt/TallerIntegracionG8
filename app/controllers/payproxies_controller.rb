class PayproxiesController < ApplicationController
  before_action :set_payproxy, only: [:show, :edit, :update, :destroy]

  # GET /payproxies
  # GET /payproxies.json
  def index
    @payproxies = Payproxy.all
  end

  # GET /payproxies/:id/sucess
  # GET /payproxies/:id/sucess.json
  def sucess
    puts "#{Time.now} - Sucess con id =  #{params[:id]}"
    puts params[:_id]
    @payproxy = Payproxy.find_by_boleta_id(params[:id])

    @payproxy.update_attribute(:state, 1)

    respond_to do |format|
      format.html { redirect_to payproxies_url, notice: 'Payproxy was successfully sucess.' }
      format.json { head :no_content }
    end
  end

  # GET /payproxies/:id/fail
  # GET /payproxies/:id/fail.json
  def fail
    @payproxy = Payproxy.find_by_boleta_id(params[:id])
    @payproxy.update_attribute(:state, 2)

    respond_to do |format|
      format.html { redirect_to payproxies_url, notice: 'Payproxy was successfully fail.' }
      format.json { head :no_content }
    end
  end

  # GET /payproxies/1
  # GET /payproxies/1.json
  def show
  end

  # GET /payproxies/new
  def new
    @payproxy = Payproxy.new

    #redirect_to("https://integracion-2017-dev.herokuapp.com/web/pagoenlinea?callbackUrl=http://integra17-8.ing.puc.cl/payproxies//5930d58f401ad500042015be/sucess&cancelUrl=http://integra17-8.ing.puc.cl/payproxies//5930d58f401ad500042015be/fail&boletaId=5930d58f401ad500042015be&")


  end

  # GET /payproxies/1/edit
  def edit
  end

  # POST /payproxies
  # POST /payproxies.json
  def create
    @payproxy = Payproxy.new(payproxy_params)
    redirect_to("https://integracion-2017-dev.herokuapp.com/web/pagoenlinea?callbackUrl=http://integra17-8.ing.puc.cl/payproxies//5930d58f401ad500042015be/sucess&cancelUrl=http://integra17-8.ing.puc.cl/payproxies//5930d58f401ad500042015be/fail&boletaId=5930d58f401ad500042015be&")

    respond_to do |format|
      if @payproxy.save
        format.html { redirect_to @payproxy, notice: 'Payproxy was successfully created.' }
        format.json { render :show, status: :created, location: @payproxy }
      else
        format.html { render :new }
        format.json { render json: @payproxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payproxies/1
  # PATCH/PUT /payproxies/1.json
  def update
    respond_to do |format|
      if @payproxy.update(payproxy_params)
        format.html { redirect_to @payproxy, notice: 'Payproxy was successfully updated.' }
        format.json { render :show, status: :ok, location: @payproxy }
      else
        format.html { render :edit }
        format.json { render json: @payproxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payproxies/1
  # DELETE /payproxies/1.json
  def destroy
    @payproxy.destroy
    respond_to do |format|
      format.html { redirect_to payproxies_url, notice: 'Payproxy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payproxy
      @payproxy = Payproxy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payproxy_params
      params.require(:payproxy).permit(:amount, :boleta_id)
    end
end
