class LinksController < ApplicationController
  before_action :set_link, except: %i[index create]
  before_action :check_if_editable?, only: %i[edit update destroy]

  def index
    @pagy, @links = pagy(Link.recent_first)
    @link ||= Link.new
  end

  def show; end

  def edit; end

  def update
    if @link.update(link_params)
      redirect_to @link
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @link = Link.new(link_params.with_defaults(user: current_user))
    if @link.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('links', @link) }
        # format.turbo_stream { render turbo_stream: [
        # turbo_stream.prepend('links', @link),
        # turbo_stream.replace('link_form', partial: 'links/form', locals: { link: Link.new}) # -> need to add id='link_form' to form partial
        # ]
        # }
      end
    else
      # alternatively: @links = Link.recent_first
      index # as long as your index method don't render anything or redirect it is fine
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    redirect_to root_path, notice: 'Link has been deleted.'
  end

  private

  def link_params
    params.required(:link).permit(:url)
  end

  def check_if_editable?
    return if @link.editable_by?(current_user)

    redirect_to @link, alert: 'You are not allowed to do that!'
  end
end
