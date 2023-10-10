class Admin::ProductsController < ApplicationController
  load_and_authorize_resource

  before_action :load_info_categories,
                only: %i(show index new create edit update)
  before_action :load_product, only: %i(show edit update destroy)
  before_action :load_category, only: :create

  def index
    @pagy, @products = pagy(Product.newest,
                            items: Settings.orders.number_of_page_5)
  end

  def show
    @feedbacks = @product.feedbacks.newest
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = @category.products.build product_params
    if @product.save
      flash[:success] = t("success")
      redirect_to admin_products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update product_params
      flash[:success] = t("product_updated")
      redirect_to admin_products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t("product_deleted")
    else
      flash[:danger] = t("deleted_failed")
    end
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :price,
                                    :description, :quantity, :rating, :image)
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t("product_not_found")
    redirect_to root_url
  end

  def load_category
    @category = Category.find_by id: params[:product][:category_id]
    return if @category

    flash[:danger] = t("category_not_found")
    redirect_to root_url
  end
end
