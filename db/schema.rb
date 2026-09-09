# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_09_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "caracteristicas", force: :cascade do |t|
    t.string "clave", null: false
    t.datetime "created_at", null: false
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["clave"], name: "index_caracteristicas_on_clave", unique: true
    t.index ["nombre"], name: "index_caracteristicas_on_nombre", unique: true
  end

  create_table "comunas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nombre", null: false
    t.bigint "region_id", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_comunas_on_nombre"
    t.index ["region_id", "nombre"], name: "index_comunas_on_region_id_and_nombre", unique: true
    t.index ["region_id"], name: "index_comunas_on_region_id"
  end

  create_table "propiedad_caracteristicas", force: :cascade do |t|
    t.bigint "caracteristica_id", null: false
    t.datetime "created_at", null: false
    t.bigint "propiedad_id", null: false
    t.datetime "updated_at", null: false
    t.index ["caracteristica_id"], name: "index_propiedad_caracteristicas_on_caracteristica_id"
    t.index ["propiedad_id", "caracteristica_id"], name: "idx_prop_carac_unique", unique: true
    t.index ["propiedad_id"], name: "index_propiedad_caracteristicas_on_propiedad_id"
  end

  create_table "propiedades", force: :cascade do |t|
    t.integer "banos"
    t.bigint "comuna_id", null: false
    t.datetime "created_at", null: false
    t.text "descripcion"
    t.boolean "destacada", default: false, null: false
    t.integer "dormitorios"
    t.integer "estacionamientos"
    t.integer "metros_construidos"
    t.integer "metros_terreno"
    t.integer "piso"
    t.integer "precio", null: false
    t.boolean "publicada", default: false, null: false
    t.string "slug"
    t.integer "tipo_inmueble", null: false
    t.integer "tipo_transaccion", null: false
    t.string "titulo", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["banos"], name: "index_propiedades_on_banos"
    t.index ["comuna_id", "precio"], name: "index_propiedades_on_comuna_id_and_precio"
    t.index ["comuna_id", "tipo_inmueble"], name: "index_propiedades_on_comuna_id_and_tipo_inmueble"
    t.index ["comuna_id", "tipo_transaccion"], name: "index_propiedades_on_comuna_id_and_tipo_transaccion"
    t.index ["comuna_id"], name: "index_propiedades_on_comuna_id"
    t.index ["created_at"], name: "index_propiedades_on_created_at"
    t.index ["destacada"], name: "index_propiedades_on_destacada"
    t.index ["dormitorios"], name: "index_propiedades_on_dormitorios"
    t.index ["precio", "tipo_inmueble"], name: "index_propiedades_on_precio_and_tipo_inmueble"
    t.index ["precio"], name: "index_propiedades_on_precio"
    t.index ["publicada"], name: "index_propiedades_on_publicada"
    t.index ["slug"], name: "index_propiedades_on_slug", unique: true
    t.index ["tipo_inmueble", "tipo_transaccion"], name: "index_propiedades_on_tipo_inmueble_and_tipo_transaccion"
    t.index ["tipo_inmueble"], name: "index_propiedades_on_tipo_inmueble"
    t.index ["tipo_transaccion"], name: "index_propiedades_on_tipo_transaccion"
  end

  create_table "regiones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nombre", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre"], name: "index_regiones_on_nombre", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "apellido_materno"
    t.string "apellido_paterno"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nombre"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.string "rut"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rut"], name: "index_users_on_rut", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comunas", "regiones"
  add_foreign_key "propiedad_caracteristicas", "caracteristicas"
  add_foreign_key "propiedad_caracteristicas", "propiedades"
  add_foreign_key "propiedades", "comunas"
end
