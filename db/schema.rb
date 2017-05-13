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

ActiveRecord::Schema.define(version: 20170512012335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "invoice_id"
    t.string   "supplier"
    t.string   "client"
    t.integer  "gross_amount"
    t.integer  "iva"
    t.integer  "total_amount"
    t.string   "status"
    t.datetime "due_date"
    t.string   "order_id"
    t.string   "rejection_motive"
    t.string   "cancellation_motive"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "order_id"
    t.string   "channel"
    t.string   "supplier"
    t.string   "client"
    t.string   "sku"
    t.integer  "amount"
    t.integer  "amount_dispatched"
    t.integer  "unit_price"
    t.datetime "delivery_date"
    t.string   "status"
    t.string   "rejection_motive"
    t.string   "cancellation_motive"
    t.string   "notes"
    t.string   "invoice_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "unit_price"
    t.string   "product_id"
    t.string   "warehouse_id"
    t.decimal  "cost",         precision: 64, scale: 12
  end

  create_table "receipts", force: :cascade do |t|
    t.string   "supplier"
    t.string   "client"
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "amount"
    t.string   "sender"
    t.string   "receiver"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warehouses", force: :cascade do |t|
    t.string   "warehouse_id"
    t.integer  "spaceUsed"
    t.integer  "spaceTotal"
    t.boolean  "reception"
    t.boolean  "dispatch"
    t.boolean  "lung"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
