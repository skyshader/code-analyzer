class Api::V1::FilesController < Api::V1::BaseController

  def get_files_by_default_branch
    files = paginate Branch.get_default_branch(params[:repository_id]).file_lists
    paginate json: files, each_serializer: FileListSerializer
  end


  def get_files_by_branch
    files = paginate Branch.get_branch(params[:name], params[:repository_id]).file_lists
    render json: files, each_serializer: FileListSerializer
  end

end
