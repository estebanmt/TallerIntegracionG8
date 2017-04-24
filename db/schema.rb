# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170424201107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string   "order_id"
    t.string   "canal"
    t.string   "proveedor"
    t.string   "cliente"
    t.string   "sku"
    t.integer  "cantidad"
    t.integer  "cantidad_despachada"
    t.integer  "precio_unitario"
    t.datetime "fecha_entrega"
    t.string   "estado"
    t.string   "motivo_rechazo"
    t.string   "motivo_anulacion"
    t.string   "notas"
    t.string   "id_factura"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
