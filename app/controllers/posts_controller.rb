class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id # Asignar el usuario actual como el dueño del post

    if @post.save
      flash[:success] = "Success!"
      redirect_to post_path(@post)
    else
      flash.now[:error] = @post.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])

    # Validar que solo el dueño del post pueda editarlo
    unless @post.user_id == current_user.id
      flash[:error] = "You are not authorized to edit this post."
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])

    # Validar que solo el dueño del post pueda actualizarlo
    if @post.user_id == current_user.id
      if @post.update(post_params)
        flash[:success] = "The post was successfully updated!"
        redirect_to post_path(@post)
      else
        flash.now[:error] = @post.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:error] = "You are not authorized to update this post."
      redirect_to posts_path
    end
  end

  def destroy
    @post = Post.find(params[:id])
  
    # Verifica si el usuario actual es el dueño del post
    if @post.user_id == current_user.id
      @post.destroy
      flash[:success] = "El post se eliminó exitosamente."
      redirect_to posts_path
    else
      flash[:error] = "No estás autorizado para eliminar este post."
      redirect_to posts_path
    end
  end
  

  private

  def post_params
    params.require(:post).permit(:description, images: [])
  end
end
