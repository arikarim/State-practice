class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: %i[ show edit update destroy ]
  # include Node
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize! :update, @post
    flow = Post.states(@post)

    if flow.into.include?(params[:post]['state'].to_sym)
      # if the user is the owner? he can update any parameters
      if @post.user_id == current_user.id
        respond_to do |format|
          if @post.update(post_params)
            redirect_to @post, notice: "Post was successfully updated."
            return
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @post.errors, status: :unprocessable_entity } and return
          end
        end
      # else, we update the state only
      else
        @post.update(state: params[:post]['state'])
        redirect_to @post, notice: "Post was successfully updated." and return
      end
      
    end
    respond_to do |format|
      format.html { redirect_to @post, notice: "You are not authorized to do this." }
      format.json { render :show, status: :unprocessable_entity, location: @post }
    end
    
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :state, :user_id)
    end
end
