class MoviesController < ApplicationController
  # before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :create, :show, :edit, :rent, :return, :update, :destroy]
  before_action :admin_user,     only: [:edit, :create, :update, :destroy]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])
    if @movie.rented_by.nil?
    else
      @myuser = User.find(@movie.rented_by)
      if @myuser.nil?
        @rented_by = nil
      else
        @rented_by = @myuser.name
      end
    end
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  def rent
    #id = params[:id]
    #SELECT.  Find takes movie id and assumes only one. returns movie in question.
    @movie = Movie.find(params[:id])
    user = current_user.id
    @movie.update_attribute(:rented_by, user)
    @movie.update_attribute(:available, false)
    if @movie.save 
      flash[:success] = "Movie successfully rented!"
      redirect_to @movie
    else 
       redirect_to movies_path, notice: 'oops! Some error occurred!'
   end 
  end

  def return
    #id = params[:id]
    #SELECT.  Find takes movie id and assumes only one. returns movie in question.
    @movie = Movie.find(params[:id])
    #mUser = @movie.read_attribute(:rented_by)
    #lUser = current_user.id
    @movie.update_attribute(:rented_by, nil)
    @movie.update_attribute(:available, true)
    if @movie.save 
      flash[:success] = "Thank you! Your movie was successfully returned!"
      redirect_to movies_path
    else 
       redirect_to movies_path, notice: 'oops! Some error occurred!'
   end 
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
   # def set_movie
     # @movie = Movie.find(params[:id])
   # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:title, :release_year, :available, :imdb_id, :poster_url, :rented_by)
    end
end
