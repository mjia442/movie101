class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         has_many :movies
         has_many :posts
         has_many :movie_relationships
         has_many :participated_movies, :through => :movie_relationships, :source => :movie
  def is_member_of?(movie)
    participated_movies.include?(movie)
  end
  def join!(movie)
    participated_movies << movie
  end

  def quit!(movie)
    participated_movies.delete(movie)
  end    
end
