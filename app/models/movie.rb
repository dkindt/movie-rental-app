class Movie < ActiveRecord::Base
  belongs_to :user
  def poster
    "http://ia.media-imdb.com/images/M/#{poster_url}"
  end

  def imdb
    "http://www.imdb.com/title/#{imdb_id}/"
  end

  def name()
  	@user = User.find(params[:rented_by]).name
  end
end
