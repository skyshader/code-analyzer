class Api::V1::BaseController < ApplicationController

  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    return api_error(error: 'The requested data was not found', status: 404)
  end

  def destroy_session
    request.session_options[:skip] = true
  end


  ## -----------------------------------------------
  # API helper methods
  ## -----------------------------------------------

  def api_error(error:, status: 401)
    render json: {success: false, message: error}, status: status
  end

end
