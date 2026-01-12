class PagesController < ApplicationController
  def about
  end

  def llm
    @posts = Post.order(published_at: :desc)
  end
end
