class TaskCommentsController < ApplicationController
  before_action :set_task_comment, only: %i[ show edit update destroy ]

  # GET /task_comments or /task_comments.json
  def index
    @task_comments = TaskComment.all
  end

  # GET /task_comments/1 or /task_comments/1.json
  def show
  end

  # GET /task_comments/new
  def new
    @task_comment = TaskComment.new
    @task_comment.task_id = params[:task_id]
  end

  # GET /task_comments/1/edit
  def edit
  end

  # POST /task_comments or /task_comments.json
  def create
    @task_comment = TaskComment.new(task_comment_params)
    @project_comment.user_id = current_user.id
    @project_comment.task_id = params[:task_id]

    respond_to do |format|
      if @task_comment.save
        format.html { redirect_to task_comment_url(@task_comment), notice: "Task comment was successfully created." }
        format.json { render :show, status: :created, location: @task_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_comments/1 or /task_comments/1.json
  def update
    respond_to do |format|
      if @task_comment.update(task_comment_params)
        format.html { redirect_to task_comment_url(@task_comment), notice: "Task comment was successfully updated." }
        format.json { render :show, status: :ok, location: @task_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_comments/1 or /task_comments/1.json
  def destroy
    @task_comment.destroy!

    respond_to do |format|
      format.html { redirect_to task_comments_url, notice: "Task comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_comment
      @task_comment = TaskComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_comment_params
      params.require(:task_comment).permit(:comment, :user_id, :task, :references)
    end
end
