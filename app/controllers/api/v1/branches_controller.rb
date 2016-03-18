class Api::V1::BranchesController < Api::V1::BaseController

  def show
    branch = Branch.find(params[:id])
    render json: branch
  end

end
