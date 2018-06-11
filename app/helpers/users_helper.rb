module UsersHelper
    def posts_exist?
        @user.posts.count > 0
    end

    def comments_exist?
        @user.comments.count > 0
    end

    def favorites_exist?
        @user.favorites.count > 0
    end 
end
