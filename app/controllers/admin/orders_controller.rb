class Admin::OrdersController < ApplicationController
  before_action :is_admin?
  before_action :load_order, only: %i(confirm cancel)

  def index
    @pagy, @orders = pagy(Order.newest, items: Settings.orders.number_of_page_5)
  end

  def confirm
    return unless @order.update(status: "confirmed")

    redirect_to admin_orders_path, notice: t("order_has_been_confirmed")
  end

  def cancel
    return unless @order.update(status: "canceled")

    redirect_to admin_orders_path, notice: t("order_has_been_cancelled")
  end

  private
  def is_admin?
    return if current_user.is_admin

    redirect_to root_path
    flash[:danger] = t("not_admin")
  end

  def load_order
    @order = Order.find_by id: params[:order_id]
    return if @order

    flash[:danger] = t("order_not_found")
    redirect_to root_url
  end
end
