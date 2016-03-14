class Api::V1::RepositoriesController < Api::V1::BaseController
    
  def show
    repository = Repository.find(params[:id])
    render json: repository
  end

end
