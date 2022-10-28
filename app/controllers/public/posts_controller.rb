class Public::PostsController < ApplicationController
  before_action :authenticate_customer!, except: [:index]
  before_action :ensure_correct_customer, only: [:edit, :update]
  before_action :set_post, only: [:show, :edit, :update]

  def index
    @posts = Post.page(params[:page]).per(10)
    @tag_list = Tag.all
  end

  def new
    @post = Post.new
    @post = current_customer.posts.new
  end

  def create
    @post = current_customer.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(nil)
    if @post.save
      @post.save_tag(tag_list)
      flash[:notice] = "新規投稿が完了しました"
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @post = Post.find(params[:id])
    @post_tags = @post.tags
  end

  def edit
    if @post.customer == current_customer
      render :edit
    else
      posts_path
    end
    @post = Post.find(params[:id])
    # tagの編集
    @tag_list=@post.tags.pluck(:tag_name).join(nil)
  end

  def update
    post = Post.find(params[:id])
    # @post.update(post_params)
    flash[:notice] = "投稿内容を変更しました"
    redirect_to post_path(@post.id)
    # tagの編集&削除
    tag_list = params[:post][:tag_name].split(nil)
    # もしpostの情報が更新されたら
    if post.update(post_params)
      # このpost_idに紐づいていたタグを@oldに入れる
      old_relations = TagMap.where(post_id: post.id)
      # それらを取り出し、消す。
      old_relations.each do |relation|
        relation.delete
      end
      post.save_tag(tag_list)
      redirect_to post_path(post.id), notice:'投稿完了しました:)'
    else
      redirect_to :action => "edit"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def tag_search
    @tag_list = Tag.all               # こっちの投稿一覧表示ページでも全てのタグを表示するために、タグを全取得
    @tag = Tag.find(params[:tag_id])  # クリックしたタグを取得
    @posts = @tag.posts.all           # クリックしたタグに紐付けられた投稿を全て表示
  end

  # def tag_search
  #   @posts = Tag.find(params[:tag_id]).posts.all  # クリックしたタグを取得


  # end

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

