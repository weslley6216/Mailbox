# frozen_string_literal: true

class DomainsController < ApplicationController
  before_action :set_domain, only: %i[show update destroy]

  def index
    @domains = Domain.all

    render json: @domains, status: :ok
  end

  def create
    @domain = Domain.new(domain_params)

    return render json: @domain, status: :created if @domain.save

    render json: @domain.errors, status: :unprocessable_entity
  end

  def show
    render json: @domain
  end

  def update
    @domain = Domain.find(params[:id])

    return render json: @domain if @domain.update(domain_params)

    render json: @domain.errors, status: :unprocessable_entity
  end

  def destroy
    @domain.destroy
  end

  private

  def domain_params
    params.require(:domain).permit(:name, :password_expiration_frequency)
  end

  def set_domain
    @domain = Domain.find(params[:id])
  end
end
