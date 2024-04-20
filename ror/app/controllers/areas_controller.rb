class AreasController < ApplicationController
  before_action :set_area, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /areas or /areas.json
  def index
    @areas = Area.where(user_id: current_user.id).order(:hierarchy)
  end

  # GET /areas/1 or /areas/1.json
  def show
    @goals = Goal.where(user_id: current_user.id, area_id: @area.id).order(:hierarchy)
    @projects = Project.where(user_id: current_user.id, area_id: @area.id).order(:hierarchy)
  end

  # GET /areas/new
  def new
    @area = Area.new
  end

  # GET /areas/1/edit
  def edit
  end

  # POST /areas or /areas.json
  def create
    @area = Area.new(area_params)
    @area.user_id = current_user.id
    @area.hierarchy = Area.where(user_id: current_user.id).maximum(:hierarchy).to_i + 1

    respond_to do |format|
      if @area.save
        if @area.isDefault
          Area.where(user_id: current_user.id)
             .where.not(id: @area.id)
             .update_all(isDefault: false)
        end
        format.html { redirect_to areas_url, notice: "Area was successfully created." }
        format.json { render :show, status: :created, location: @area }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /areas/1 or /areas/1.json
  def update
    respond_to do |format|
      if @area.update(area_params)
        if @area.isDefault
           Area.where(user_id: current_user.id)
                .where.not(id: @area.id)
                .update(isDefault: false)
        end
        format.html { redirect_to areas_url, notice: "Area was successfully updated." }
        format.json { render :show, status: :ok, location: @area }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1 or /areas/1.json
  def destroy
    Goal.where(user_id: current_user.id)
        .where(area_id: @area.id)
        .update_all(area_id: nil)
    Project.where(user_id: current_user.id)
           .where(area_id: @area.id)
           .update_all(area_id: nil)
    @area.destroy!

    Area.where(user_id: current_user.id)
        .where('hierarchy > ?', @area.hierarchy)
        .update_all('hierarchy = hierarchy - 1')

    respond_to do |format|
      format.html { redirect_to areas_url, notice: "Area was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /areas/1 or /areas/1.json
  def up
    id = params[:id]
    h_old = params[:hierarchy].to_i
    if h_old == 1
      return
    end
    Area.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old - 1)

    Area.where(user_id: current_user.id)
          .where(hierarchy: h_old - 1)
          .where.not(id: id)
          .update(hierarchy: h_old)

    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { render areas_url, status: :ok }
    end
  end

  def down
    id = params[:id]
    h_old = params[:hierarchy].to_i
    max_hierarchy = Area.where(user_id: current_user.id).maximum(:hierarchy)
    if h_old == max_hierarchy
      return
    end
    Area.where(user_id: current_user.id)
        .where(id: id)
        .update(hierarchy: h_old + 1)

    Area.where(user_id: current_user.id)
        .where(hierarchy: h_old + 1)
        .where.not(id: id)
        .update(hierarchy: h_old)
    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { render areas_url, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_area
      @area = Area.find(params[:id])
      if @area.user_id != current_user.id
        redirect_to areas_url, notice: "You can't access this area"
      end
    end

    # Only allow a list of trusted parameters through.
    def area_params
      params.require(:area).permit(:name, :hierarchy, :isDefault)
    end
end
