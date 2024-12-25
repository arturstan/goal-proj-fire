class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :set_areas, only: %i[ new edit create update ]
  before_action :set_goals, only: %i[ new edit create update ]
  before_action :set_tags, only: %i[ new edit create update ]
  before_action :set_project_statuses, only: %i[ index ]
  before_action :set_project_stars, only: %i[ index ]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    @projects = Project.where(user_id: current_user.id)
    @projects = @projects.where(status: params[:status]) if params[:status].present?
    @projects = @projects.where(star: params[:star]) if params[:star].present?
    @projects = @projects.order(:hierarchy)

    @status = params[:status] if params[:status].present?
    @star = params[:star] if params[:star].present?

  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    if (area_default = Area.where(user_id: current_user.id, isDefault: true).first)
      @project.area_id = area_default.id
    else
      @project.area_id = params[:area_id]
    end
    # @project.tags.build
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
        handle_tags_project
        if params[:return_area_id].present?
          format.html { redirect_to area_path(params[:return_area_id]), notice: "Project was successfully updated." }
        elsif params[:return_goal_id].present?
          format.html { redirect_to goal_path(params[:return_goal_id]), notice: "Project was successfully updated." }
        elsif params[:return_project_id].present?
          format.html { redirect_to project_path(params[:return_project_id]), notice: "Project was successfully updated." }
        else
          format.html { redirect_to projects_url, notice: "Project was successfully updated." }
        end
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
        handle_tags_project
        if params[:return_area_id].present?
          format.html { redirect_to area_path(params[:return_area_id]), notice: "Project was successfully updated." }
        elsif params[:return_goal_id].present?
          format.html { redirect_to goal_path(params[:return_goal_id]), notice: "Project was successfully updated." }
        elsif params[:return_project_id].present?
          format.html { redirect_to project_path(params[:return_project_id]), notice: "Project was successfully updated." }
        else
          format.html { redirect_to projects_url, notice: "Project was successfully updated." }
        end
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

    Project.where(user_id: current_user.id)
        .where('hierarchy > ?', @project.hierarchy)
        .update_all('hierarchy = hierarchy - 1')

    Task.where('project_id = (?)', @project.id).delete_all()

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
      format.html { redirect_to projects_url }
      format.json { render projects_url, status: :ok }
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
      format.html { redirect_to projects_url }
      format.json { render projects_url, status: :ok }
    end
  end

  def exchange_hierarchy
    id = params[:id]
    project_exchange_id = params[:project_exchange_id]
    h_old = params[:hierarchy].to_i
    if h_old == 1
      return
    end

    project2 = Project.find_by(user_id: current_user.id, id: project_exchange_id)
    if project2 == nil
      return
    end
    Project.where(user_id: current_user.id)
           .where(id: id)
           .update(hierarchy: project2.hierarchy)

    Project.where(id: project_exchange_id)
           .update(hierarchy: h_old)

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { render projects_url, status: :ok }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      if @project.user_id != current_user.id
        redirect_to projects_url, notice: "You can't access this project"
      end
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

  def set_tags
    @tags = Tag.where(user_id: current_user.id).order(name: :asc)
  end

  def set_project_statuses
    @project_statuses = [['all', nil]] +
      [['active', :active]] +
      [['suspended', :suspended]] +
      [['scheduled', :scheduled]] +
      [['someday', :someday]] +
      [['archived', :archived]]
  end

  def set_project_stars
    @project_stars = [['all', nil]] +
      [['star', true]] +
      [['no star', false]]
  end

  def handle_tags_project
    if params[:tag_ids]
      @project.tags.clear
      tags = params[:tag_ids].map { |id| Tags.find(id) }
      @project.tags << tags
    end
  end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:area_id, :goal_id, :name, :description, :hierarchy, :status, :start_date, :due_date, :star, tag_ids: [])
    end
end
