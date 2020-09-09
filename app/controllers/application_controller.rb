class ApplicationController < ActionController::API

  def authenticate!
    render_unauthorized and return unless request.headers['Authorization'].present?
    @token               = request.headers['Authorization']
    @sub                 = TokenService.decode @token.split(' ').last
    @current_member_user = MemberUser.find(@sub[:userId])
  rescue JWT::VerificationError, JWT::DecodeError => e
    Rails.logger.error e.message
    render_unauthorized
  end

end
