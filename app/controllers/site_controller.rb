class SiteController < ApplicationController
  def index
    if current_user
      # retrieve all Songs ordered by descending creation timestamp
      @songs = current_user.songs.order('updated_at desc')
    end
  end
end
