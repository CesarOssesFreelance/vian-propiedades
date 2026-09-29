class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user_management!
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.order(:apellido_paterno, :nombre, :email)
  end

  def new
    @user = User.new(role: :admin)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: "Usuario creado correctamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    attributes = user_params
    attributes = attributes.except(:password, :password_confirmation) if attributes[:password].blank?

    if removing_last_super_admin?(attributes)
      @user.errors.add(:role, "debe conservar al menos un superadministrador")
      render :edit, status: :unprocessable_content
    elsif @user.update(attributes)
      redirect_to users_path, notice: "Usuario actualizado correctamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "No puedes eliminar tu propia cuenta."
    elsif @user.super_admin? && User.super_admin.one?
      redirect_to users_path, alert: "Debe existir al menos un superadministrador."
    else
      @user.destroy!
      redirect_to users_path, notice: "Usuario eliminado correctamente.", status: :see_other
    end
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end

  def user_params
    params.expect(user: [
      :nombre, :apellido_paterno, :apellido_materno, :rut, :email,
      :role, :password, :password_confirmation
    ])
  end

  def removing_last_super_admin?(attributes)
    @user.super_admin? && attributes[:role] != "super_admin" && User.super_admin.one?
  end
end
