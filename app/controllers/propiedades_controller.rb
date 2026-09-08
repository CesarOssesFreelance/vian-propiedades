class PropiedadesController < ApplicationController
  before_action :set_propiedad, only: %i[ show edit update destroy ]

  # GET /propiedades or /propiedades.json
  def index
    @propiedades = Propiedad.all
  end

  # GET /propiedades/1 or /propiedades/1.json
  def show
  end

  # GET /propiedades/new
  def new
    @propiedad = Propiedad.new
  end

  # GET /propiedades/1/edit
  def edit
  end

  # POST /propiedades or /propiedades.json
  def create
    @propiedad = Propiedad.new(propiedad_params)

    respond_to do |format|
      if @propiedad.save
        format.html { redirect_to @propiedad, notice: "Propiedad was successfully created." }
        format.json { render :show, status: :created, location: @propiedad }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @propiedad.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /propiedades/1 or /propiedades/1.json
  def update
    respond_to do |format|
      if @propiedad.update(propiedad_params)
        format.html { redirect_to @propiedad, notice: "Propiedad was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @propiedad }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @propiedad.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /propiedades/1 or /propiedades/1.json
  def destroy
    @propiedad.destroy!

    respond_to do |format|
      format.html { redirect_to propiedades_path, notice: "Propiedad was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_propiedad
      @propiedad = Propiedad.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def propiedad_params
      params.expect(propiedad: [ :titulo, :descripcion, :precio, :dormitorios, :banos, :estacionamientos, :metros_construidos, :metros_terreno, :piso, :tipo_inmueble, :comuna_id ])
    end
end
