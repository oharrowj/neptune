class ErrorController < ApplicationController

  def invalid
    render :xml => { "Error" => "Invalid URL" }, status: 404
  end

end
