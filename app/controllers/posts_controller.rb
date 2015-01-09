class PostsController < ApplicationController
  before_filter :authenticate, :except => [ :index, :show, :tagged ]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :init

  # GET /posts
  # GET /posts.json
  def index
    #@blog = Blog.first
    #@posts = Post.all.order(created_at: :desc)
    @posts = Post.all
    @posts = @posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /tagged/tag
  def tagged
    #@blog = Blog.first
    @posts = Post.tagged_with(params[:query])
    @posts = @posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 5)
  end

  def archive
    #par = params[:query]
    #@posts = Post.where("MONTH(date) = ? AND YEAR(date) = ?", par[-2], par[0,4])
    @date1 = Date.new params[:date][:year].to_i, params[:date][:month].to_i, 01
    @date2 = Date.new params[:date][:year].to_i, params[:date][:month].to_i, -1
    @posts = Post.where("DATE(created_at) >= DATE(?) AND DATE(created_at) <= DATE(?)", @date1, @date2)
    @posts = @posts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 5)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      #@blog = Blog.first
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :tag_list)
    end

    # requer senha para postar
    def authenticate
      authenticate_or_request_with_http_basic do |name, password|
        name == "blogmaster" && password == "senha"
      end
    end

    def init
      if Blog.first.blank?
        redirect_to blogs_path
      end
      @blog = Blog.first
      @title = @blog.title
    end
end
