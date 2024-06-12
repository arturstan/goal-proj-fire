class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_areas, only: %i[ new edit create update ]
  before_action :set_projects, only: %i[ new edit create update ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.where(user_id: current_user.id)
    # todo filter
    @tasks.order(:hierarchy)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    if params[:project_id].present?
      @task.area_id = params[:area_id]
      @task.project_id = params[:project_id]
    else
      if params[:area_id].present?
        @task.area_id = params[:area_id]
      else
        if (area_default = Area.where(user_id: current_user.id, isDefault: true).first)
          @task.area_id = area_default.id
        end
      end
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    @task.hierarchy = Task.where(user_id: current_user.id).maximum(:hierarchy).to_i + 1

    respond_to do |format|
      if @task.save
        if params[:return_project_id].present?
          format.html { redirect_to project_path(params[:return_project_id]), notice: "Task was successfully created." }
        else
          format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        end
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        if params[:return_project_id].present?
          format.html { redirect_to project_path(params[:return_project_id]), notice: "Task was successfully updated." }
          #format.html { redirect_to area_path(params[:return_area_id]), notice: "Goal was successfully updated." }
        else
          format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        end
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

  def set_areas
    @areas = [['', nil]] +
      Area.where(user_id: current_user.id).order(:hierarchy)
          .map { |area| [area.name, area.id] }
  end

  def set_projects
    @projects = [['', nil]] +
      Project.where(user_id: current_user.id).order(:hierarchy)
          .map { |proj| [proj.name, proj.id] }
  end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :status, :star, :start_date, :due_date, :energy, :time, :user_id, :area_id, :project_id)
    end
end
