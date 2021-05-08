class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_user, only: :show
  before_action :set_current_user, only: %i[edit update]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      sweetalert_success t('users.notice.updated')
      redirect_to @user
    else
      render :edit
    end
  end

  # def destroy
  #   @user.destroy
  #   redirect_to events_path
  #   sweetalert_success(t('users.notice.destroyed'))
  # end

  private

  def set_current_user
    @user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
