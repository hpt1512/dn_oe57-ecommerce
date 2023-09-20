class FeedbacksController < ApplicationController
  before_action :logged_in_user

  def new
    @feedback = Feedback.new
    @product = Product.find_by id: params[:product_id]
  end

  def create
    ActiveRecord::Base.transaction do
      @product = find_product
      @feedback = Feedback.new(
        product: @product,
        user: current_user,
        content: params[:feedback][:content],
        rating: params[:feedback][:rating]
      )
      @feedback.save!
      update_rating_product @product
      flash[:success] = t("success")
      redirect_to @product
    end
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_entity
  end

  private

  def find_product
    Product.find_by id: (params[:feedback][:product_id])
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("please_log_in")
    store_location
    redirect_to login_url
  end

  def update_rating_product product
    rating_feedback = Feedback.filter_by_product_id(product.id)
    average_rating = rating_feedback.average(:rating).round(0)
    product.rating = average_rating
    product.save!
  end
end
