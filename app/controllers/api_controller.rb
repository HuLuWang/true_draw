class ApiController < ApplicationController

  def test
    render json: {code: 200, message: "test ok"}
  end
end