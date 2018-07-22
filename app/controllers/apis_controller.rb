class ApisController < ApplicationController
  before_action :set_api, only: [:show, :edit, :update, :destroy]
  before_action :auth_me

  def index
    @apis = Api.get_apis(current_user)
  end

  def show
  end

  def new
    @api = Api.new
    @api.user_id = current_user.id
  end

  def edit
  end

  def create
    @api = Api.new(api_params)
    @api.user_id = current_user.id

    if @api.save
      redirect_to @api
    else
      render 'new'
    end
  end

  def update
    if @api.update(api_params)
      redirect_to @api
    else
      render 'edit'
    end
  end

  def destroy
    @api.destroy
    redirect_to apis_path
  end

  private
    def set_api
      @api = Api.find(params[:id])
      if current_user.id != @api.user_id
        redirect_to apis_path
      end
    end

    def api_params
      params.require(:api).permit(:name, :api_type, :api_key, :secret_key)
    end

    def auth_me
      if not current_user
        redirect_to user_google_oauth2_omniauth_authorize_path
      end
    end
end
