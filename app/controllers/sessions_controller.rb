class SessionsController < ApplicationController
  layout "login"

  def new
    redirect_to dashboard_path if logged_in?
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Usuário ou senha inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Sessão encerrada."
  end
end
