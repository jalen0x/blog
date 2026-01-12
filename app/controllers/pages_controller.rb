class PagesController < ApplicationController
  def about
  end

  def llm
    @posts = Post.order(published_at: :desc)
  end

  def sitemap
    @posts = Post.order(published_at: :desc)
    expires_in 1.hour, public: true
  end
end
