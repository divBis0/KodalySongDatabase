class SiteController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user
      # retrieve all Songs ordered by descending creation timestamp
      @songs = current_user.songs.order('updated_at desc').page(params[:page])
    end
  end
end
