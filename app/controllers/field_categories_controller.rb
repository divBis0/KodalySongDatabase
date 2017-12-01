class FieldCategoriesController < ApplicationController
  before_action :set_field_category, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authenticate_admin!

  # GET /field_categories
  # GET /field_categories.json
  def index
    @field_categories = FieldCategory.order(:order)
  end

  # GET /field_categories/1
  # GET /field_categories/1.json
  def show
  end

  # GET /field_categories/new
  def new
    @field_category = FieldCategory.new
  end

  # GET /field_categories/1/edit
  def edit
  end

  # POST /field_categories
  # POST /field_categories.json
  def create
    @field_category = FieldCategory.new(field_category_params)

    respond_to do |format|
      if @field_category.save
        format.html { redirect_to @field_category, notice: 'Field category was successfully created.' }
        format.json { render :show, status: :created, location: @field_category }
      else
        format.html { render :new }
        format.json { render json: @field_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_categories/1
  # PATCH/PUT /field_categories/1.json
  def update
    respond_to do |format|
      if @field_category.update(field_category_params)
        format.html { redirect_to @field_category, notice: 'Field category was successfully updated.' }
        format.json { render :show, status: :ok, location: @field_category }
      else
        format.html { render :edit }
        format.json { render json: @field_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_categories/1
  # DELETE /field_categories/1.json
  def destroy
    @field_category.destroy
    respond_to do |format|
      format.html { redirect_to field_categories_url, notice: 'Field category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_category
      @field_category = FieldCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def field_category_params
      params.require(:field_category).permit(:name, :order)
    end
end
