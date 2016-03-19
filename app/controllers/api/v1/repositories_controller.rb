class Api::V1::RepositoriesController < Api::V1::BaseController

  ##
  # List all repositories for a project
  #
  def all_by_project
    repositories = Repository.find_by_project_id(params[:project_id])
    render json: repositories
  end


  ##
  # Get one repository, by its id
  #
  def get
    repository = Repository.find(params[:id])
    render json: repository
  end

end
