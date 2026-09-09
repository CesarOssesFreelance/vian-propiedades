class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def sign_up_params
    params.require(:user).permit(:nombre, :apellido_paterno, :apellido_materno, :rut,
                                :email, :password, :password_confirmation)
  end

  def build_resource(attributes = {})
    super
    resource.role = :corredor
  end
end
