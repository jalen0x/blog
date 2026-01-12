class PostsController < ApplicationController
  def index
    @posts = Post.order(published_at: :desc)
  end

  def show
    @post = Post.find_by!(slug: params.expect(:slug))

    respond_to do |format|
      format.html
      format.md { render plain: @post.body, content_type: "text/markdown" }
    end
  end

  def feed
    @posts = Post.order(published_at: :desc).limit(20)
    expires_in 1.hour, public: true
  end
end
