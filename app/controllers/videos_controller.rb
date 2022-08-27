class VideosController < ApplicationController
  before_action :authorized, except: :index
  before_action :set_video, only: [:edit, :update, :destroy]

  def index
    @videos = Video.includes(:user)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(params[:per_page])
  end

  def new
    @video = current_user.videos.build
  end

  def create
    @video = current_user.videos.build(video_params)

    if @video.save
      redirect_to root_path, notice: 'Successfully shared video'
    else
      flash.now[:error] = @video.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @video.update(video_params)
      redirect_to root_path, notice: 'Successfully updated video'
    else
      flash.now[:error] = @video.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video.destroy
    redirect_to root_path, notice: 'Successfully deleted video'
  end

  private

  def video_params
    params.require(:video).permit(:title, :url, :description)
  end

  def set_video
    @video = current_user.videos.find_by(id: params[:id])
    redirect_to root_path, flash: { error: 'You are not permitted to perform this action' } unless @video
  end
end
