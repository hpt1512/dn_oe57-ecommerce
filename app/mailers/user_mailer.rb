class UserMailer < ApplicationMailer
  def confirm_order order
    @order = order
    mail(to: @order.user.email, subject: 'Confirmed Order')
  end

  def cancel_order order, reason
    @order = order
    @reason = reason
    mail(to: @order.user.email, subject: 'Canceled Order')
  end
end
