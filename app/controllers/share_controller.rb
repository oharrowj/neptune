class ShareController < ApplicationController

  def create
    if params["key"].blank? or params["key"].to_s != ENV["NEPTUNE_KEY"].to_s
      render :xml => { "Error" => "Unauthorized" }, status: 401
    else
      if params["filename"].blank?
        render :xml => { "Error" => "Request could not be processed" }, status: 400
      else
        filename = params["filename"] +".xml"
        data = request.body.read
        path = "/home/mercury/logs/"+filename

        File.open(path, "w+") do |f|
          f.write(data)
        end

        share = Share.find_by(:name => filename )
        if share.blank?
          share = Share.new
        end
        share.name = filename
        share.path = path
        share.timestamp = DateTime.now
        if share.save
          redirect_to root_url
        else
          File.delete(path) if File.exist?(path)
          render :xml => { "Error" => "Request could not be processed" }, status: 400
        end
      end
    end
  end

  def index
    @shares = Share.all
    @shares = @shares.page(params[:page]).per(25)
  end

  def show
    share = Share.find_by(:id => params[:id])
    if share.blank?
      render :xml => { "Error" => "Resource Not Found" }, status: 404
    elsif !File.exist?( share.path )
      share.delete
      render :xml => { "Error" => "Resource Not Found" }, status: 404  
    else
      data = File.open( share.path ).read()
      render :xml => data
    end
  end

end
