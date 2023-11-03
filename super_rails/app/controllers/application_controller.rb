class ApplicationController < ActionController::Base
  include Pagy::Backend
  include MarkdownHelper

  before_action :authenticate_user!


  def after_sign_in(resource)
    user_path(resource)
  end
end
