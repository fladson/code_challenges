class ApplicationController < ActionController::API
  rescue_from RailsParam::Param::InvalidParameterError do |e|
    render json: { message: e.message }, status: :unprocessable_entity
  end
end
