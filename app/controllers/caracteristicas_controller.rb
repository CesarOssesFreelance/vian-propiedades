class CaracteristicasController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_catalog_management!
  before_action :set_caracteristica, only: %i[ edit update destroy ]

  # GET /caracteristicas or /caracteristicas.json
  def index
    @caracteristicas = Caracteristica.all
  end


  # GET /caracteristicas/new
  def new
    @caracteristica = Caracteristica.new
  end

  # GET /caracteristicas/1/edit
  def edit
  end

  # POST /caracteristicas or /caracteristicas.json
  def create
    @caracteristica = Caracteristica.new(caracteristica_params)

    respond_to do |format|
      if @caracteristica.save
        format.html { redirect_to caracteristicas_path, notice: "Caracteristica was successfully created." }
        format.json { render :show, status: :created, location: @caracteristica }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @caracteristica.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /caracteristicas/1 or /caracteristicas/1.json
  def update
    respond_to do |format|
      if @caracteristica.update(caracteristica_params)
        format.html { redirect_to caracteristicas_path, notice: "Caracteristica was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @caracteristica }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @caracteristica.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /caracteristicas/1 or /caracteristicas/1.json
  def destroy
    @caracteristica.destroy!

    respond_to do |format|
      format.html { redirect_to caracteristicas_path, notice: "Caracteristica was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caracteristica
      @caracteristica = Caracteristica.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def caracteristica_params
      params.expect(caracteristica: [ :nombre, :clave ])
    end
end
