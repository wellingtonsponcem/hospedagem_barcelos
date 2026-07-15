require "net/http"
require "json"

class CitiesController < ApplicationController
  def index
    cities = Rails.cache.fetch("ibge_cities", expires_in: 30.days) do
      uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/municipios")
      response = Net::HTTP.get(uri)
      data = JSON.parse(response)
      data.map do |c|
        uf = c.dig("microrregiao", "mesorregiao", "UF", "sigla") || 
             c.dig("regiao-imediata", "regiao-intermediaria", "UF", "sigla") || 
             "UF"
        { cidade: c["nome"], uf: uf }
      end
    end
    render json: cities
  end
end
