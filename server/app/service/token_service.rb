class TokenService

  ALGORITHM = Rails.application.config_for(:jwt_token)['algorithm']
  SECRET    = JWT::Base64.url_decode Rails.application.config_for(:jwt_token)['secret']

  def self.encode(sub)
    payload = {iat: Time.now.to_i, exp: Time.now.to_i + 24 * 60 * 60}
                  .merge!(sub)
    JWT.encode(payload, SECRET, ALGORITHM)
  end

  def self.decode(token)
    payload = JWT.decode(token, SECRET, true, {algorithms: ALGORITHM})
    payload.first.symbolize_keys!
  end
end
