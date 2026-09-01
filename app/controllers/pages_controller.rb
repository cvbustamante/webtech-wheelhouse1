class PagesController < ApplicationController
  def home
  end

  def services
    @jobs = [
      { name: "Tune-up", price: 35000 },
      { name: "Wheel true", price: 15000 },
      { name: "Brake bleed", price: 20000 },
      { name: "Chain replacement", price: 12000 },
      { name: "Flat tyre repair", price: 8000 },
      { name: "Brake adjustment", price: 10000 },
      { name: "Gear adjustment", price: 10000 },
      { name: "Tyre replacement", price: 12000 },
      { name: "Tube replacement", price: 8000 },
      { name: "Pedal replacement", price: 10000 },
      { name: "Handlebar adjustment", price: 8000 },
      { name: "Bike inspection", price: 15000 }
    ]
  end

  def visiting
  end

  def about
  end
end