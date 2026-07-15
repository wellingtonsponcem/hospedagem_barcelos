require "net/http"
require "json"

class CitiesController < ApplicationController
  def index
    cities = Rails.cache.fetch("ibge_cities", expires_in: 30.days) do
      uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/municipios")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      data.map { |c| { cidade: c["nome"], uf: c["microrregiao"]["mesorregiao"]["UF"]["sigla"] } }
    end
    render json: cities
  end
end
