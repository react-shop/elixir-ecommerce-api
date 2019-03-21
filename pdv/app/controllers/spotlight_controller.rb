class SpotlightController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, :only => [:index, :show]

  # GET /spotlight
  def index
    @products = Product.where(spotlight: true)

    render json: {data: @products}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:sku, :item, :color, :size, :cod, :stock)
    end
end
