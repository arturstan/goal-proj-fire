class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ show edit update destroy ]
  before_action :set_areas, only: %i[ new edit create update ]
  before_action :authenticate_user!

  # GET /goals or /goals.json
  def index
    @goals = Goal.where(user_id: current_user.id).order(:hierarchy)
  end

  # GET /goals/1 or /goals/1.json
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new
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
        Rails.logger.debug "Area ID: #{params[:area_id]}"
        if params[:area_id].present?
          format.html { redirect_to area_path(params[:area_id]), notice: "Goal was successfully updated." }
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
    @goal.destroy!

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

    # Only allow a list of trusted parameters through.
    def goal_params
      params.require(:goal).permit(:area_id, :name, :description, :hierarchy, :status)
    end
end
