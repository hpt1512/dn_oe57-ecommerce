class ApplicationController < ActionController::Base
  include Pagy::Backend
  # app/controllers/application_controller.rb
  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
