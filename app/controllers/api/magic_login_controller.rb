module Api
  class MagicLoginController < ApiBaseController
    load_and_authorize_resource :user, only: %i[index edit new update destroy]
    authorize_resource :user, only: :create

    def index
      if current_user.role != 'admin' && current_user.role != 'superadmin'
        render status: 401, json: { message: 'Not authenticated' }
        return
      end

      email = params[:email]
      if email.nil?
        render status: 400, json: { message: 'Email is required' }
        return
      end

      user = User.find_by(email: email)

      if user
        # Generate token for existing user
        token = user.generate_login_token!
        magic_link = "#{Docuseal::DEFAULT_APP_URL}/magic_login/?token=#{token}"
        render json: { "magic link" => magic_link }
      else
        # Create new user and generate token
        user_params = { email: email, password: SecureRandom.hex(8), role: 'user', first_name: params[:first_name] }
        @user = current_account.users.new(user_params)

        if @user.save
          token = @user.generate_login_token!
          magic_link = "#{Docuseal::DEFAULT_APP_URL}/magic_login/?token=#{token}"
          render json: { "magic link" => magic_link }
        else
          render status: 400, json: { message: @user.errors.full_messages.to_sentence }
        end
      end
    end
  end
end
