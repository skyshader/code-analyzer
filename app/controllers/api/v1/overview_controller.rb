class Api::V1::OverviewController < Api::V1::BaseController

  ##
  # Get overview for a repository - default branch
  #
  def get_default
    # repository = Repository.find(params[:repository_id])
    branch = Branch.get_default_branch(params[:repository_id])
    # overview = Overview.for_repository(repository, branch)
    render json: branch, serializer: BranchOverviewSerializer, include: [
      'language_stats.supported_language',
      'category_stats.issue_category',
      'files',
      'current_issues',
      'current_request',
      'last_completed_request',
    ]
  end

  ##
  # Get overview for a repository - requested branch
  #
  def get_by_branch
    # repository = Repository.find(params[:repository_id])
    branch = Branch.get_branch(params[:name], params[:repository_id])
    # overview = Overview.for_repository(repository, branch)
    render json: branch, serializer: BranchOverviewSerializer, include: [
      'current_language_stats.supported_language',
      'category_stats.issue_category',
      'files',
      'current_issues',
      'current_request',
      'last_completed_request',
    ]
  end

end
