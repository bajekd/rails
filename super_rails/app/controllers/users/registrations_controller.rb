# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

end
