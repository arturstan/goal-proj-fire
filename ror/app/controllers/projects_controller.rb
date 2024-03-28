class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_areas, only: %i[ new edit ]
  before_action :set_goals, only: %i[ new edit ]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    @projects = Project.where(user_id: current_user.id).order(:hierarchy)
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    @project.hierarchy = Project.where(user_id: current_user.id).maximum(:hierarchy).to_i + 1

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_url(@project), notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_url(@project), notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def up
    id = params[:id]
    h_old = params[:hierarchy].to_i
    if h_old == 1
      return
    end
    Project.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old - 1)

    Project.where(user_id: current_user.id)
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
    max_hierarchy = Project.where(user_id: current_user.id).maximum(:hierarchy)
    if h_old == max_hierarchy
      return
    end
    Project.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old + 1)

    Project.where(user_id: current_user.id)
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
    def set_project
      @project = Project.find(params[:id])
    end

    def set_areas
      @areas = [['', nil]] +
        Area.where(user_id: current_user.id).order(:hierarchy)
            .map { |area| [area.name, area.id] }
    end

    def set_goals
      @goals = [['', nil]] +
        Goal.where(user_id: current_user.id).order(:hierarchy)
            .map { |goal | [goal.name, goal.id] }
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:area_id, :goal_id, :name, :description, :hierarchy, :status, :start_date, :due_date, :star)
    end
end
