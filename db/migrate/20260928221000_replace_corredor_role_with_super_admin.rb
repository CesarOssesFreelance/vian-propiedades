class ReplaceCorredorRoleWithSuperAdmin < ActiveRecord::Migration[8.1]
  def up
    # El valor 1 antes representaba a corredores. Desde ahora queda reservado
    # para superadministradores; los corredores existentes pasan a admin.
    execute "UPDATE users SET role = 0 WHERE role = 1"
  end

  def down
    execute "UPDATE users SET role = 1 WHERE role = 0"
  end
end
