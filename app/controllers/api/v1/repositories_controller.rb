class Api::V1::RepositoriesController < Api::V1::BaseController

  ##
  # List all repositories for a project
  #
  def all
    repositories = Repository.where(params[:project_id])
    render json: repositories
  end


  def show
    repository = Repository.find(params[:id])
    render json: repository
  end

end
