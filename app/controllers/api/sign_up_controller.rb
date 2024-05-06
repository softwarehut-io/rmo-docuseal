module Api
  class SignUpController < ApiBaseController
    load_and_authorize_resource :user, only: %i[index edit new update destroy]
    authorize_resource :user, only: :create


    def create
      if current_user.role !='admin'
        render :status => 401,
        :json => {:message => 'Not authenticated'}
        return
      elsif params[:user][:email].nil?
        render :status => 400,
        :json => {:message => 'User request must contain the user email.'}
        return
      elsif params[:user][:password].nil?
        render :status => 400,
        :json => {:message => 'User request must contain the user password.'}
        return
      end

      if params[:user][:email]
        duplicate_user = User.find_by_email(params[:email])
        unless duplicate_user.nil?
          render :status => 409,
          :json => {:message => 'Duplicate email. A user already exists with that email address.'}
          return
        end
      end

      @user = current_account.users.new(user_params)

      if @user.save!
        render :json => {:user => @user, "x-token"=>current_user.access_token.token}
      else
        render :status => 400,
        :json => {:message => @user.errors.full_messages}
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :role)
    end
  end
end
