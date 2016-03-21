class Api::V1::BranchesController < Api::V1::BaseController

  ##
  # Get one branch, default by repository id
  #
  def get_default
    branch = Branch.get_default_branch(params[:repository_id])
    render json: branch
  end

  ##
  # Get one branch, by repository id and branch name
  #
  def get_by_name
    branch = Branch.find_by_name_and_repository_id(params[:name], params[:repository_id])
    render json: branch
  end

end
