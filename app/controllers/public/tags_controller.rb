class Public::TagsController < ApplicationController
  def index
    @tag = Tag.page(params[:page]).per(10)

    if params[:search] != nil && params[:search] != ''
      search = params[:search]
      @tag_list = Tag.where("tag_name LIKE ?", "%#{search}%")
    else
      @tag_list = Tag.all.sort {|a,b| b.posts.count <=> a.posts.count}
    end
  end
  private

  def post_params
    params.require(:post).permit(:body, :title)
  end
end
