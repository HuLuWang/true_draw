class ApplicationController < ActionController::API
  before_action :authenticate!

  def authenticate!
    render_unauthorized and return unless request.headers['Authorization'].present?
    @token               = request.headers['Authorization']
    @sub                 = TokenService.decode @token
    @user = User.find(@sub[:user_id])
  rescue JWT::VerificationError, JWT::DecodeError => e
    Rails.logger.error e.message
    render_unauthorized
  end

  private

  def render_unauthorized
    render json: {code: ErrCode::NotAuth, msg: 'unauthorized'}, status: :unauthorized
  end
end
