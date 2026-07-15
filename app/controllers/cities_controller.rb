class CitiesController < ApplicationController
  def index
    cities = Rails.cache.fetch("cities_json", expires_in: 30.days) do
      file_path = Rails.root.join("public", "cities.json")
      data = JSON.parse(File.read(file_path))
      parsed = []
      data["estados"].each do |est|
        uf = est["sigla"]
        est["cidades"].each do |cid|
          parsed << { cidade: cid, uf: uf }
        end
      end
      parsed
    end
    render json: cities
  end
end
