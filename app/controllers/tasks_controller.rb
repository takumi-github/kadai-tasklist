class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :require_user_logged_in
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(3)
    end
  end
  
  def show
  end
  
  def new
    if logged_in?
    @task = current_user.tasks.build
    end
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "Taskが正常に投稿されました"
      redirect_to @task
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = "Task が投稿されませんでした"
      render :new
    end  
  end
  
  def edit
      @task = current_user.tasks.build
  end
  
  def update
    
    if @task.update(task_params)
      flash[:success] = "Task は更新されました"
      redirect_to @task
    else
      flash.now[:danger] = "Task は更新されませんでした"
      render :edit
    end  
  end
  
  def destroy
    @task.destroy
    
    flash[:success] = "Task は正常に削除されました"
    redirect_to tasks_url
  end  
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end  
  
  def task_params
    params.require(:task).permit(:content, :status)
  end  
end

