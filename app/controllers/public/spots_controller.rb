class Public::SpotsController < ApplicationController
  before_action :authenticate_customer!

  def index

    @posts = Post.all
    gon.posts = Post.all
    @markers = Post.all.map do |post|
      { id: post.id, latitude: post.latitude, longitude: post.longitude, address: post.address, evaluation: post.evaluation, title: post.title }
    end.to_json
  end

  def post_params
      params.require(:post).permit(:title,:lat,:lng)
  end



end
