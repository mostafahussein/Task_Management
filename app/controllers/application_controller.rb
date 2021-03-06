class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_i18n_locale_from_params

  rescue_from CanCan::AccessDenied do |exception|
  	redirect_to_back exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to_back exception.message
  end

  def redirect_to_back msg=""
  	if !request.env["HTTP_REFERER"].blank? and
  	 request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back, notice: msg
    else
      redirect_to root_url, notice: msg
    end
  end

  protected

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
        "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
