require 'sinatra'
require "sinatra/json"
require "sinatra/reloader"
require 'thin'
require 'pry'
require 'lib/klarna'

if ENV['KLARNA_API_KEY'].nil? && ENV['KLARNA_API_SECRET'].nil?
  raise "KLARNA_API_KEY and KLARNA_API_SECRET environment variables not set"
end

Klarna.configure do |config|
  config.environment = :test
  config.country = ENV.fetch("KLARNA_REGION") { :us }.to_sym
  config.api_key = ENV["KLARNA_API_KEY"]
  config.api_secret = ENV["KLARNA_API_SECRET"]
end

class FakeFrontend < Sinatra::Base
  set :server, 'thin'
  set :sessions, true
  set :reloader, true

  get '/' do
    erb :layout, :layout => false do
      erb :index
    end
  end

  post '/session' do
    return json( token: session[:token] ) if session.has_key?(:token)
    response = Klarna.client(:credit).create_session(order())
    session[:token] = response.client_token
    json token: response.client_token
  end

  delete '/session' do
    session.delete(:token) if session.has_key?(:token)
    json status: true
  end

  post '/order' do
    result = Klarna.client(:credit).place_order(params[:authorization_token], order())
    session.delete(:token) if session.has_key?(:token)

    if result.success?
      json({
        success: result.success?,
        order_id: result.order_id,
        redirect_url: result.body['redirect_url'],
        fraud_status: result.fraud_status
        })
    else
      json({
        success: result.success?,
        error_code: result.error_code,
        error_messages: result.error_messages,
        correlation_id: result.correlation_id
        })
    end
  end
end

def order()
  data = {
    purchase_country: "US" ,
    purchase_currency: "USD" ,
    order_amount: "10",
    order_tax_amount: "1",
    order_lines: [
      {
        type: "physical",
        reference: "19­-402-­USA",
        name: "Battery Power Pack",
        quantity: "1",
        quantity_unit: "kg",
        unit_price: "10",
        tax_rate: "10",
        total_amount: "10",
        total_discount_amount: "0",
        total_tax_amount: "1",
        product_url: "https://www.estore.com/products/f2a8d7e34",
        image_url: "https://www.exampleobjects.com/logo.png"
      }
    ]
  }
  data.merge!(
    billing_address: params[:billing_address],
    shipping_address: params[:shipping_address]
  )
end
