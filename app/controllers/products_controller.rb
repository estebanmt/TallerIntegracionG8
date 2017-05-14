class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]


  # GET /products
  def index
    @products = Product.all

    #render json: @products
    render json: '[{
    "id": 1,
    "name": "Producto 1",
    "sku": "abc123",
    "unit_price": 5
}, {
    "id": 2,
    "name": "Producto 2",
    "sku": "abc456",
    "unit_price": 100
}]'

  end

  # GET /products/1
  def show
    #render json: @product
    render json: '{
    "id": 1,
    "name": "Producto 1",
    "sku": "abc123",
    "unit_price": 5
}'
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name, :sku)
    end
end
