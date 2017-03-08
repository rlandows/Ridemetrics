require 'json'

class RidemetricsController < ApplicationController


  def index
    @ridemetrics = Ridemetric.all

    options = {
          headers: {
            Authorization: 'Bearer gAAAAABYs293hYE8UiYL1UCwblFeqrG37XOfsZZ4aacAhFOO0o8NOd5uZWvH_LZBk6VvExKLC2499Je53zJpyznIRf7F3GT-TpJMW1s0ce3IwEs16AqETCF2vSO15p6optnFslzA5buSmiv8kVCifH2ZoLE-KrfOJ_R5-cdr3g9XdCbjHGvPb3w='
          }.as_json,
          query: {
            start_lat: 33.600586,
            start_lng: -117.673649,
            end_lat: 33.577938,
            end_lng: -117.701651
          }
        }

    @lyft_cost = HTTParty.get("https://api.lyft.com/v1/cost", options)
    json = JSON.parse(@lyft_cost.body)
    cost_min = (json['cost_estimates'][0]['estimated_cost_cents_min'])/ 100
    # lyft_client = Lyft.configure do |config|
    #   config.client_id     = "aH1tkQSXqcA6"
    #   config.client_secret = "mBfU0PMvhq6rDbOvqSLvuXNfUWvOuE0u"
    # end

    puts "hello #{cost_min}"

  end

  def show
    @ridemetrics = Ridemetric.all
    @ridemetric = @ridemetrics[@ridemetrics.length - 1]


    client = Uber::Client.new do |config|
      config.server_token  = "AcjexFXp4SVNlHI5DFWEBGwSugu-hamXRtx-liQP"
    end

  @price = client.price_estimations(start_latitude: @ridemetric.start_lat, start_longitude: @ridemetric.start_long,
                         end_latitude: @ridemetric.end_lat, end_longitude: @ridemetric.end_long )
  @time = client.time_estimations(start_latitude: @ridemetric.start_lat, start_longitude: @ridemetric.start_long)
  puts "#{@price}"


  #Lyft cost
  options = {
        headers: {
          Authorization: 'Bearer gAAAAABYs293hYE8UiYL1UCwblFeqrG37XOfsZZ4aacAhFOO0o8NOd5uZWvH_LZBk6VvExKLC2499Je53zJpyznIRf7F3GT-TpJMW1s0ce3IwEs16AqETCF2vSO15p6optnFslzA5buSmiv8kVCifH2ZoLE-KrfOJ_R5-cdr3g9XdCbjHGvPb3w='
        }.as_json,
        query: {
          start_lat: @ridemetric.start_lat,
          start_lng: @ridemetric.start_long,
          end_lat: @ridemetric.end_lat,
          end_lng: @ridemetric.start_long
        }
      }

  @lyft_cost = HTTParty.get("https://api.lyft.com/v1/cost", options)
  json = JSON.parse(@lyft_cost.body)
  @cost_min = (json['cost_estimates'][0]['estimated_cost_cents_min'])/ 100

  #lyft eta
  options2 = {
        headers: {
          Authorization: 'Bearer gAAAAABYs293hYE8UiYL1UCwblFeqrG37XOfsZZ4aacAhFOO0o8NOd5uZWvH_LZBk6VvExKLC2499Je53zJpyznIRf7F3GT-TpJMW1s0ce3IwEs16AqETCF2vSO15p6optnFslzA5buSmiv8kVCifH2ZoLE-KrfOJ_R5-cdr3g9XdCbjHGvPb3w='
        }.as_json,
        query: {
          lat: @ridemetric.start_lat,
          lng: @ridemetric.start_long,

        }
      }

      @lyft_eta = HTTParty.get("https://api.lyft.com/v1/eta", options2)
      json2 = JSON.parse(@lyft_eta.body)
      @lyft_eta2 = (json2['eta_estimates'][0]['eta_seconds']) / 60
      puts "#{@lyft_eta2}"

  end

  def create
    @ridemetrics = Ridemetric.new(ridemetric_params)


    if @ridemetrics.save
      redirect_to :action => :show, notice: "Topic was saved successfully."

    end
    client = Uber::Client.new do |config|
      config.server_token  = "AcjexFXp4SVNlHI5DFWEBGwSugu-hamXRtx-liQP"
    end
  @price = client.price_estimations(start_latitude: 33.600586, start_longitude: -117.673649, end_latitude: 33.577938, end_longitude: -117.701651)
  puts "#{@price[0].estimate}"

  end

  def new
    @ridemetrics = Ridemetric.new
    client = Uber::Client.new do |config|
      config.server_token  = "AcjexFXp4SVNlHI5DFWEBGwSugu-hamXRtx-liQP"
    end
    @price = client.price_estimations(start_latitude: 33.600586, start_longitude: -117.673649,
                           end_latitude: 33.577938, end_longitude: -117.701651)

  end

  private
 def ridemetric_params
   params.require(:ridemetric).permit(:start_lat, :start_long, :end_lat, :end_long)
 end
end
