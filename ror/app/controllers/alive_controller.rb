class AliveController < ApplicationController
  def alive
    render json: { data: 'Ok' }
  end
end