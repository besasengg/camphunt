class ApplicationController < ActionController::Base

	protect_from_forgery with: :exception
	#protect_from_forgery with: null_session
	after_action :set_csrf_token

  def set_csrf_token
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end