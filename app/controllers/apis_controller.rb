class ApisController < ApplicationController
  before_action :authenticate_me

  def index
    @apis = Api.all
  end

  def show
    @api = Api.find(params[:id])
  end

  def new
    @api = Api.new
  end

  def edit
    @api = Api.find(params[:id])
  end

  def create
    @api = Api.new(api_params)

    if @api.save
      redirect_to @api
    else
      render 'new'
    end
  end

  def update
    @api = Api.find(params[:id])

    if @api.update(api_params)
      redirect_to @api
    else
      render 'edit'
    end
  end

  def destroy
    @api = Api.find(params[:id])
    @api.destroy

    redirect_to apis_path
  end

  private
    def api_params
      params.require(:api).permit(:name, :api_type, :api_key, :secret_key)
    end

    def authenticate_me
      if not current_user
        redirect_to user_google_oauth2_omniauth_authorize_path
      end
    end

end
