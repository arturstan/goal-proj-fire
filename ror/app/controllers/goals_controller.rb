class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ show edit update destroy delete_with_projects ]
  before_action :set_areas, only: %i[ new edit create update ]
  before_action :set_goal_statuses, only: %i[ index ]
  before_action :authenticate_user!

  # GET /goals or /goals.json
  def index
    if params[:status].present?
      @goals = Goal.where(user_id: current_user.id).where(status: params[:status]).order(:hierarchy)
      @status = params[:status]
    else
      @goals = Goal.where(user_id: current_user.id).order(:hierarchy)
    end
  end

  # GET /goals/1 or /goals/1.json
  def show
    @projects = Project.where(user_id: current_user.id, goal_id: @goal.id).order(:hierarchy)
  end

  # GET /goals/new
  def new
    @goal = Goal.new
    if area_default = Area.where(user_id: current_user.id, isDefault: true).first
      @goal.area_id = area_default.id
    end
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals or /goals.json
  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    @goal.hierarchy = Goal.where(user_id: current_user.id).maximum(:hierarchy).to_i + 1

    respond_to do |format|
      if @goal.save
        format.html { redirect_to goals_url, notice: "Goal was successfully created." }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1 or /goals/1.json
  def update
    respond_to do |format|
      if @goal.update(goal_params)
        if params[:return_area_id].present?
          format.html { redirect_to area_path(params[:return_area_id]), notice: "Goal was successfully updated." }
        else
          format.html { redirect_to goals_url, notice: "Goal was successfully updated." }
        end
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1 or /goals/1.json
  def destroy
    Project.where(user_id: current_user.id)
           .where(goal_id: @goal.id)
           .update_all(goal_id: nil)
    @goal.destroy!

    Goal.where(user_id: current_user.id)
        .where('hierarchy > ?', @goal.hierarchy)
        .update_all('hierarchy = hierarchy - 1')

    respond_to do |format|
      format.html { redirect_to goals_url, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_with_projects
    Project.where(user_id: current_user.id)
           .where(goal_id: @goal.id)
           .delete_all
    @goal.destroy!

    Goal.where(user_id: current_user.id)
        .where('hierarchy > ?', @goal.hierarchy)
        .update_all('hierarchy = hierarchy - 1')

    respond_to do |format|
      format.html { redirect_to goals_url, notice: "Goal was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def up
    id = params[:id]
    h_old = params[:hierarchy].to_i
    if h_old == 1
      return
    end
    Goal.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old - 1)

    Goal.where(user_id: current_user.id)
        .where(hierarchy: h_old - 1)
        .where.not(id: id)
        .update(hierarchy: h_old)

    respond_to do |format|
      format.html { redirect_to goals_url }
      format.json { render goals_url, status: :ok }
    end
  end

  def down
    id = params[:id]
    h_old = params[:hierarchy].to_i
    max_hierarchy = Goal.where(user_id: current_user.id).maximum(:hierarchy)
    if h_old == max_hierarchy
      return
    end
    Goal.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old + 1)

    Goal.where(user_id: current_user.id)
        .where(hierarchy: h_old + 1)
        .where.not(id: id)
        .update(hierarchy: h_old)
    respond_to do |format|
      format.html { redirect_to goals_url }
      format.json { render goals_url, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
      if @goal.user_id != current_user.id
        redirect_to goals_url, notice: "You can't access this goal"
      end
    end

    def set_areas
      @areas = [['', nil]] +
        Area.where(user_id: current_user.id).order(:hierarchy)
            .map { |area| [area.name, area.id] }
    end

  def set_goal_statuses
    @goal_statuses = [['all', nil]] +
      [['active', :active]] +
      [['important', :important]] +
      [['suspended', :suspended]] +
      [['someday', :someday]] +
      [['archived', :archived]]
  end

    # Only allow a list of trusted parameters through.
    def goal_params
      params.require(:goal).permit(:area_id, :name, :description, :hierarchy, :status)
    end
end
