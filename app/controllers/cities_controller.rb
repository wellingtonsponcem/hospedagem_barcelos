class CitiesController < ApplicationController
  def index
    file_path = Rails.root.join("public", "cities.json")
    data = JSON.parse(File.read(file_path))
    cities = []
    data["estados"].each do |est|
      uf = est["sigla"]
      est["cidades"].each do |cid|
        cities << { cidade: cid, uf: uf }
      end
    end
    render json: cities
  end
end
