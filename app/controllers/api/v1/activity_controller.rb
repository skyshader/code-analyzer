class Api::V1::ActivityController < Api::V1::BaseController

  def index
    render :text => "Activity: Write code to test here!", :layout => true
  end

end
