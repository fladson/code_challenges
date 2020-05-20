class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render plain: '404 Not Found', status: 404
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
