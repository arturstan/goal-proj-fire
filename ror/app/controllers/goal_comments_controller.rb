class GoalCommentsController < ApplicationController
  before_action :set_goal_comment, only: %i[ show edit update destroy ]

  # GET /goal_comments or /goal_comments.json
  def index
    @goal_comments = GoalComment.all
  end

  # GET /goal_comments/1 or /goal_comments/1.json
  def show
  end

  # GET /goal_comments/new
  def new
    @goal_comment = GoalComment.new
    @goal_comment.goal_id = params[:goal_id]
  end

  # GET /goal_comments/1/edit
  def edit
  end

  # POST /goal_comments or /goal_comments.json
  def create
    @goal_comment = GoalComment.new(goal_comment_params)
    @goal_comment.user_id = current_user.id
    @goal_comment.goal_id = params[:goal_id]

    respond_to do |format|
      if @goal_comment.save
        format.html { redirect_to goal_url(id: params[:goal_id]), notice: "Goal comment was successfully created." }
        format.json { render :show, status: :created, location: @goal_comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goal_comments/1 or /goal_comments/1.json
  def update
    respond_to do |format|
      if @goal_comment.update(goal_comment_params)
        format.html { redirect_to goal_path(id: @goal_comment.goal_id), notice: "Goal comment was successfully updated." }
        format.json { render :show, status: :ok, location: @goal_comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal_comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goal_comments/1 or /goal_comments/1.json
  def destroy
    @goal_comment.destroy!

    respond_to do |format|
      format.html { redirect_to goal_url(@goal_comment.goal_id), notice: "Goal comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal_comment
      @goal_comment = GoalComment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def goal_comment_params
      params.require(:goal_comment).permit(:comment, :goal_id)
    end
end
