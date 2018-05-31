class PostsController < ApplicationController
    before_action :require_sign_in, except: :show

    def show
        @post = Post.find(params[:id])
    end

    def new
        @topic = Topic.find(params[:topic_id])
        @post = Post.new
    end

    def create
        @topic = Topic.find(params[:topic_id])
        # @post = Post.new
        # @post.title = params[:post][:title]
        # @post.body = params[:post][:body]
        # @post.topic = @topic
        @post = @topic.posts.build(post_params)
        @post.user = current_user

        if @post.save
            flash[:notice] = "Post was saved."
            redirect_to [@topic, @post]
        else
            flash.now[:alert] = "There was an error saving the post. Please try again."
            render :new
        end
    end

    def edit
        post = Post.find(params[:id])
        if current_user == post.user || current_user.admin? || current_user.moderator?
            @post = Post.find(params[:id])
        else
            flash[:alert] = "You must be an admin or moderator to do that."
            redirect_to [post.topic, post]
        end
    end

    def update
        @post = Post.find(params[:id])
        # @post.title = params[:post][:title]
        # @post.body = params[:post][:body]
        @post.assign_attributes(post_params)

        if @post.save
            flash[:notice] = "Post was updated."
            redirect_to [@post.topic, @post]
        else
            flash.now[:alert] = "There was an error saving the post. Please try again."
            render :edit
        end
    end

    def destroy
        post = Post.find(params[:id])
        if current_user == post.user || current_user.admin?
            @post = Post.find(params[:id])
            if @post.destroy
                flash[:notice] = "\"#{@post.title}\" was deleted sucessfully."
                redirect_to @post.topic
            else
                flash.now[:alert] = "There was an error deleting the post."
                render :show
            end
        else
            flash[:alert] = "You must be an admin to do that."
            redirect_to [post.topic, post]
        end
    end

    private
    def post_params
        params.require(:post).permit(:title, :body)
    end
end
