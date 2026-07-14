class CheckoutsController < ApplicationController
  before_action :require_login

  def show
    redirect_to reservations_path
  end

  def update
    redirect_to reservations_path
  end
end
