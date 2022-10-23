class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.page(params[:page]).per(10)
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def destroy
    customer = Customer.find(params[:id])
    customer.destroy
    redirect_to admin_customers_path
  end

  private

  def customer_params
    params.require(:customer).permit(:customername, :introduction, :profile_image)
  end
end
