module Api
  class GenerateLinkController < ApiBaseController
    load_and_authorize_resource :user, only: %i[index edit new update destroy]
    authorize_resource :user, only: :create

    def index
      user = User.find_by(email: params[:email])
      token =  user.generate_login_token!

      if user && (current_user.role =='admin'|| current_user.role =='superadmin')
        render :json => {"magic link"=> "#{Docuseal::DEFAULT_APP_URL}/magic_login/?token=#{token}"
        }
      elsif current_user.role !='admin' && current_user.role !='superadmin'
        render :status => 401,
        :json => {:message => 'Not authenticated'}
      else
        render :status => 400,
        :json => {:message => user.errors.full_messages ||= 'Not authenticated'}
      end
    end
  end
end
