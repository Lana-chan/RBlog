class BlogsController < ApplicationController
  before_filter :authenticate
  # singleton pattern
  #def self.instance
  #  @ __instance__ ||= new
  #end

  # GET /blogs/new
  def index
    if Blog.first.blank?
      @blog = Blog.new
    else
      #render plain: 'Blog ja existe.'
      @blog = Blog.first
    end
  end

  def show
  end

  def create
    @blog = Blog.new(blog_params)
    respond_to do |format|
      if @blog.save
        format.html { redirect_to blogs_path, notice: 'Blog was successfully created.' }
        format.json { render :index, status: :created, location: @blog }
      else
        format.html { render :index }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @blog = Blog.first
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blogs_path, notice: 'Blog was successfully updated.' }
        format.json { render :index, status: :ok, location: @blog }
      else
        format.html { render :index }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :description, :author)
    end

    # requer senha para postar
    def authenticate
      authenticate_or_request_with_http_basic do |name, password|
        name == "blogmaster" && password == "senha"
      end
    end
end
