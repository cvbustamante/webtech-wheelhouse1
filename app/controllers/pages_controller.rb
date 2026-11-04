class PagesController < ApplicationController
  # paginas fijas sin registros, iguales para cualquier cuenta: ver docs/decisions.md
  skip_after_action :verify_authorized

  def home
  end

  def visiting
  end

  def about
  end
end
