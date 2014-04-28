class TopicsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create, :edit]
  before_action :find, except: [:index, :create, :new]

  def index
    @topics = Topic.all.includes(:photos).order('id desc')
  end

  def new
    @topic = Topic.new
  end

  def show
  end

  def create
    @topic = Topic.new(topic_params)

    @topic.user_id = current_user.id
    @topic.node_id = params[:node] || topic_params[:node_id]
    #@topic.photo = params[:photo] || topic_params[:photo]
    logger.info '*' * 80
    logger.info @topic

    if @topic.save
      redirect_to(topic_path(@topic.id), :notice => t("topics.create_topic_success"))
    else
      render :action => "new"
    end
  end

  protected

  def find
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :body, :node_id, :photo => {:id => []})
  end
end
