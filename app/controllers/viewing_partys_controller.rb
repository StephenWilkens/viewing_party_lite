class ViewingPartysController < ApplicationController
  def new
    if current_user
      @user = current_user
    else
      flash[:error] = 'You must be logged in or registered to acceses that page'
      redirect_to login_path
    end
    @movie = MovieFacade.new.movie_details(params[:movie_id])
    @users = User.all
  end

  def create
    movie = MovieFacade.new.movie_details(params[:movie_id])
    duration = params[:duration].to_i
    host_id = params[:host_id]
    if duration >= movie.runtime
      @new_party = ViewingParty.create(party_params)
    else
      flash[:error] = 'Duration can not be shorter than movie runtime'
      redirect_to new_movie_viewing_party_path(movie.id)
    end
    attendees = params[:usernames]

    if defined?(@new_party)
      attendees.each do |id, checked|
        if checked == "1"
          Attendee.create(viewing_party_id: @new_party.id, user_id: id)
        end
      end
      redirect_to users_dashboard_path
    end
  end

  private

  def party_params
    params.permit(:movie, :movie_id, :date, :start_time, :duration, :host_id)
  end

  def attendee_params
    params.permit(:user_id, :movie_id)
  end
end