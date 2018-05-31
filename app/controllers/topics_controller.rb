class TopicsController < ApplicationController
    before_action :require_sign_in, except: [:index, :show]

    def index
        @topics = Topic.all
    end

    def show
        @topic = Topic.find(params[:id])
    end

    def new
        if current_user.admin?
            @topic = Topic.new
        else
            flash[:alert] = "You must be an admin to do that."
            redirect_to topics_path
        end
    end

    def create
        if current_user.admin?
            # @topic = Topic.new
            # @topic.name = params[:topic][:name]
            # @topic.description = params[:topic][:description]
            # @topic.public = params[:topic][:public]
            @topic = Topic.new(topic_params)

            if @topic.save
                flash[:notice] = "Topic was saved."
                redirect_to @topic, notice: "Topic was saved successfully"
            else
                flash.now[:alert] = "Error creating topic. Please try again."
                render :new
            end
        else
            flash[:alert] = "You must be an admin to do that."
            redirect_to topics_path
        end
    end

    def edit
        if current_user.admin? || current_user.moderator?
            @topic = Topic.find(params[:id])
        else
            flash[:alert] = "You must be an admin or moderator to do that."
            redirect_to topics_path
        end
    end

    def update
        if current_user.admin? || current_user.moderator?
            @topic = Topic.find(params[:id])
            # @topic.name = params[:topic][:name]
            # @topic.description = params[:topic][:description]
            # @topic.public = params[:topic][:public]
            @topic.assign_attributes(topic_params)

            if @topic.save
                flash[:notice] = "topic was updated."
                redirect_to @topic
            else
                flash.now[:alert] = "There was an error saving the topic. Please try again."
                render :edit
            end
        else
            flash[:alert] = "You must be an admin or moderator to do that."
            redirect_to topics_path
        end
    end

    def destroy
        if current_user.admin?
            @topic = Topic.find(params[:id])

            if @topic.destroy
                flash[:notice] = "\"#{@topic.name}\" was deleted sucessfully."
                redirect_to action: :index
            else
                flash.now[:alert] = "There was an error deleting the topic."
                render :show
            end
        else
            flash[:alert] = "You must be an admin to do that."
            redirect_to topics_path
        end
    end

    private
    def topic_params
        params.require(:topic).permit(:name, :description, :public)
    end
end
