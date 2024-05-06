class MagicLoginController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def index
    redirect_to root_path unless params[:token].present?

    user = User.find_by(login_token: params[:token])
    if user
      sign_in(user)
      user.update_column(:login_token, nil)
      redirect_to root_path , notice: 'Logged in successfully!'
    else
      redirect_to root_path, alert: 'The link you used was invalid. Please request a new login link'
    end
  end
end
