class PagesController < ApplicationController
  def home
  end

  def services
    @jobs = Job.order(:name)
  end

  def visiting
  end

  def about
  end
end