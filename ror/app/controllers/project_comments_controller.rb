class ProjectCommentsController < ApplicationController
  before_action :set_project_comment, only: %i[ show edit update destroy ]

  # GET /project_comments or /project_comments.json
  def index
    @project_comments = ProjectComment.all
  end

  # GET /project_comments/1 or /project_comments/1.json
  def show
  end

  # GET /project_comments/new
  def new
    @project_comment = ProjectComment.new
    @project_comment.project_id = params[:project_id]
  end

  # GET /project_comments/1/edit
  def edit
  end

  # POST /project_comments or /project_comments.json
  def create
    @project_comment = ProjectComment.new(project_comment_params)
    @project_comment.user_id = current_user.id
    @project_comment.project_id = params[:project_id]

    respond_to do |format|
      if @project_comment.save
        format.html { redirect_to project_url(id: params[:project_id]), notice: "Project comment was successfully created." }
        format.json { render :show, status: :created, location: @project_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_comments/1 or /project_comments/1.json
  def update
    respond_to do |format|
      if @project_comment.update(project_comment_params)
        format.html { redirect_to project_path(id: @project_comment.project_id), notice: "Project comment was successfully updated." }
        format.json { render :show, status: :ok, location: @project_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_comments/1 or /project_comments/1.json
  def destroy
    @project_comment.destroy!

    respond_to do |format|
      format.html { redirect_to project_url(@project_comment.project_id), notice: "Project comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project_comment
    @project_comment = ProjectComment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_comment_params
    params.require(:project_comment).permit(:comment, :project_id)
  end
end
