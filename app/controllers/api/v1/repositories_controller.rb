class Api::V1::RepositoriesController < Api::V1::BaseController

  ##
  # List all repositories for a project
  #
  def all_by_project
    repositories = Repository.where(project_id: params[:project_id])
    raise ActiveRecord::RecordNotFound unless repositories
    render json: repositories, each_serializer: RepositorySerializer, include: [
      'branches',
      'default_branch',
      'branches.current_request',
      'branches.last_completed_request',
    ]
  end


  ##
  # Get one repository, by its id
  #
  def get
    repository = Repository.find(params[:id])
    raise ActiveRecord::RecordNotFound unless repositories
    render json: repository
  end

end
