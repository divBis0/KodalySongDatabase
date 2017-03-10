class SiteController < ApplicationController
  def index
    # retrieve all Songs ordered by descending creation timestamp
    @songs = Song.order('created_at desc')
  end
end
