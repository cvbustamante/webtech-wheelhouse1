class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  # crear cuenta no tiene policy, ver docs/decisions.md
  skip_after_action :verify_authorized

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      # el mail sale desde un job, despues de la respuesta
      WelcomeMailer.welcome(@user).deliver_later
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Welcome to Wheelhouse, #{@user.email_address}."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  # sin role ni staff_member: eso se cambia solo desde el seed o la consola
  def registration_params
    params.expect(user: [:email_address, :password, :password_confirmation])
  end
end
