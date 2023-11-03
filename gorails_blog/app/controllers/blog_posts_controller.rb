class BlogPostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_blog_post, except: %i[index new create]

  def index
    # because of index.html action -> n+1 query -> preload all cover_images before views explicity ask for them
    @blog_posts = user_signed_in? ? BlogPost.sorted : BlogPost.published.sorted
    @pagy, @blog_posts = pagy(@blog_posts)
    # rescue Pagy::OverflowError
    #   redirect_to root_path(page: @pagy.last)
    #
    # although this make another request
    #   params[:page] = @pagy.last
    #   retry
  end

  def show; end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blog_post_params)
    if @blog_post.save
      redirect_to @blog_post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @blog_post.update(blog_post_params)
      redirect_to @blog_post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to root_path
  end

  private

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :cover_image, :published_at)
  end

  def set_blog_post
    @blog_post = user_signed_in? ? BlogPost.find(params[:id]) : BlogPost.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end
end