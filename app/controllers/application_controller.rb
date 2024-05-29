class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :domain_not_found

  def domain_not_found
    render json: { error: 'Domain not found' }, status: :not_found
  end
end
