class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :ensure_correct_customer, only: [:edit, :update]
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      flash[:notice] = "新規投稿が完了しました"
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
  end

  def edit
    if @post.customer == current_customer
      render :edit
    else
      posts_path
    end
  end

  def update
    @post.update(post_params)
    flash[:notice] = "投稿内容を変更しました"
    redirect_to post_path(@post.id)
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(
      :title, :body, :spot_image, :chillout, :atmosphere, :beautiful, :access, :congestion, :evaluation, :address)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path
    end
  end
end

