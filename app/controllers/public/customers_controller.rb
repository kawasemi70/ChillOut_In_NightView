class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_guest_customer, only: [:edit, :update]
  before_action :set_customer, only: [:show, :edit, :update]

  def index
    @customer = current_customer
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
  end

  def edit
    redirect_to customer_path(current_customer.id) unless @customer == current_customer
  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = "登録情報を変更しました"
      redirect_to customer_path(@customer.id)
    else
      render :edit
    end
  end

  def favorites
    @customer = Customer.find(params[:customer_id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end


  private

  def customer_params
    params.require(:customer).permit(:customername, :introduction, :profile_image)
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.customername == "guestuser"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません'
    end
  end
end
