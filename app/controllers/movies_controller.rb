class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @movies = Movie.all
  end
  def show
    @movie = Movie.find(params[:id])
    @posts = @movie.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end
  def new
    @movie = Movie.new
  end
  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
      current_user.join!(@movie)
       redirect_to movies_path
    else
       render :new
     end
  end
  def edit

  end
  def update

    if @movie.update(movie_params)
      redirect_to movies_path, notice: "Update Success"
    else
      render :edit
    end
  end
  def destroy

    @movie.destroy
    flash[:alert] = "Movie deleted"
    redirect_to movies_path
  end
  def join
    @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.join!(@movie)
      flash[:notice] = "收藏本影片成功"
    else
      flash[:warning] = "您已收藏该影片"
    end
    redirect_to movie_path(@movie)
  end

  def quit
    @movie = Movie.find(params[:id])
    if current_user.is_member_of?(@movie)
      current_user.quit!(@movie)
      flash[:alert] = "已取消收藏该影片"
    else
      flash[:warning] = "您还未收藏该影片，怎么退出 XD"
    end
    redirect_to movie_path(@movie)

  end

  private
  def find_movie_and_check_permission
    @movie = Movie.find(params[:id])

    if current_user != @movie.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
  def movie_params
  params.require(:movie).permit(:title, :description)
  end

end
