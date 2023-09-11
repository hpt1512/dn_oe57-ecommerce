class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def create
    # byebug
    category = Category.find_by id: params[:product][:category_id]
    @product = category.products.build product_params
    if @product.save
      flash[:success] = "OK"
      redirect_to root_url
    end
  end

  def product_params
    params.require(:product).permit(:name,:price,:description,:quantity,:rating,:image)
  end
end
