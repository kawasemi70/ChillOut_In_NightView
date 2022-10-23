class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :spot_image,:chillout, :atmosphere, :beautiful, :access, :congestion, :evaluation, :address)
  end
end
