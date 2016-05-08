class ErrorController < ApplicationController

  def invalid
    render :xml => { "Error" => "Access Forbidden" }, status: 403
  end

end
