class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :system_settings

  def system_settings
    @system_settings ||= begin
      file_path = Rails.root.join("config", "settings.json")
      if File.exist?(file_path)
        JSON.parse(File.read(file_path))
      else
        {
          "price_standard" => "180,00",
          "price_executiva" => "250,00",
          "price_shower" => "25,00",
          "price_towel" => "45,00",
          "price_other" => "100,00"
        }
      end
    end
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Por favor, faça login para continuar."
    end
  end
end
