class PropiedadesController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show ]
  before_action :authorize_catalog_management!, except: %i[ index show ]
  before_action :set_propiedad, only: %i[ show edit update destroy ]

  # GET /propiedades or /propiedades.json
  def index
    @comunas = Comuna.where(id: Propiedad.select(:comuna_id)).order(:nombre)
    @propiedades = Propiedad.includes(:comuna).preload(imagenes_attachments: :blob)
    @propiedades = @propiedades.where(comuna_id: params[:comuna_id]) if params[:comuna_id].present?
    @propiedades = @propiedades.where(tipo_inmueble: params[:tipo_inmueble]) if params[:tipo_inmueble].present?
    if Propiedad.defined_enums.fetch("tipo_transaccion").key?(params[:tipo_transaccion])
      @propiedades = @propiedades.where(tipo_transaccion: params[:tipo_transaccion])
    end
    if params[:precio_max].to_s.match?(/\A\d+\z/)
      @propiedades = @propiedades.where("precio <= ?", params[:precio_max].to_i)
    end
    @propiedades = @propiedades.order(destacada: :desc, created_at: :desc, id: :desc)
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
      @propiedad = Propiedad.friendly.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def propiedad_params
      attributes = params.expect(propiedad: [
        :titulo, :descripcion, :precio, :dormitorios, :banos, :estacionamientos,
        :metros_construidos, :metros_terreno, :piso, :tipo_inmueble,
        :tipo_transaccion, :destacada, :publicada, :comuna_id,
        :video_url, :imagen_principal, imagenes: [], caracteristica_ids: []
      ])
      attributes.delete(:imagen_principal) if attributes[:imagen_principal].blank?
      uploads = attributes.delete(:imagenes)&.reject(&:blank?)
      if uploads.present?
        attributes[:imagenes] = (@propiedad&.imagenes&.blobs&.to_a || []) + uploads
      end
      attributes
    end
end
