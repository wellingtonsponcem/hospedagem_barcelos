require "net/http"
require "json"

class CitiesController < ApplicationController
  def index
    cities = Rails.cache.fetch("local_gist_cities", expires_in: 30.days) do
      begin
        # Use Gist as static cities source for complete lists, falling back to IBGE API if it fails
        uri = URI("https://gist.githubusercontent.com/letanure/3012978/raw/6938daa8ba69bcafa89a8c719690225641e39586/estados-cidades.json")
        response = Net::HTTP.get(uri)
        data = JSON.parse(response)
        
        parsed = []
        data["estados"].each do |est|
          uf = est["sigla"]
          est["cidades"].each do |cid|
            parsed << { cidade: cid, uf: uf }
          end
        end
        parsed
      rescue => e
        Rails.logger.error "Error fetching cities from Gist: #{e.message}. Falling back to IBGE..."
        
        # Defensive fallback to IBGE API
        begin
          fallback_uri = URI("https://servicodados.ibge.gov.br/api/v1/localidades/municipios")
          fallback_response = Net::HTTP.get(fallback_uri)
          fallback_data = JSON.parse(fallback_response)
          fallback_data.map do |c|
            uf = c.dig("microrregiao", "mesorregiao", "UF", "sigla") || 
                 c.dig("regiao-imediata", "regiao-intermediaria", "UF", "sigla") || 
                 "UF"
            { cidade: c["nome"], uf: uf }
          end
        rescue => fb_err
          Rails.logger.error "Error fetching cities from IBGE: #{fb_err.message}"
          []
        end
      end
    end
    render json: cities
  end
end
