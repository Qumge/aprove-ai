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

ActiveRecord::Schema[8.1].define(version: 2020_05_16_113231) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string "achievement"
    t.string "agent_status"
    t.integer "apply_id"
    t.string "business"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "desc"
    t.integer "members"
    t.string "name"
    t.string "phone"
    t.string "product"
    t.string "resources"
    t.string "scale"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "username"
    t.index ["deleted_at"], name: "index_agents_on_deleted_at"
  end

  create_table "attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "file_name"
    t.integer "model_id"
    t.string "model_type"
    t.string "path"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_attachments_on_deleted_at"
  end

  create_table "audit_details", force: :cascade do |t|
    t.integer "audit_id"
    t.datetime "created_at", null: false
    t.boolean "status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.string "from_status"
    t.integer "model_id"
    t.string "model_type"
    t.string "status"
    t.string "to_status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "desc"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "competitors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "desc"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "advance_time"
    t.datetime "created_at", null: false
    t.string "cycle"
    t.datetime "deleted_at"
    t.string "name"
    t.string "no"
    t.text "others"
    t.string "partner"
    t.integer "process_time"
    t.string "product"
    t.integer "settlement_time"
    t.integer "tail_time"
    t.datetime "updated_at", null: false
    t.datetime "valid_date"
    t.index ["deleted_at"], name: "index_contracts_on_deleted_at"
  end

  create_table "cost_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "desc"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "costs", force: :cascade do |t|
    t.float "amount"
    t.integer "cost_category_id"
    t.datetime "created_at", null: false
    t.datetime "occur_time"
    t.string "purpose"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "deliver_logs", force: :cascade do |t|
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "deliver_at"
    t.integer "order_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "delivers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "number"
    t.integer "order_id"
    t.string "phone"
    t.string "phone_to"
    t.datetime "updated_at", null: false
  end

  create_table "factories", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.text "desc"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "fund_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "fund_at"
    t.integer "order_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.float "amount"
    t.datetime "applied_at"
    t.datetime "apply_at"
    t.datetime "created_at", null: false
    t.string "invoice_status"
    t.string "no"
    t.integer "project_id"
    t.datetime "sended_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "code"
    t.string "content"
    t.datetime "created_at", null: false
    t.integer "fee"
    t.string "from"
    t.string "msg"
    t.string "send_id"
    t.string "status"
    t.string "template_id"
    t.string "to"
    t.string "type"
    t.datetime "updated_at", null: false
  end

  create_table "notices", force: :cascade do |t|
    t.string "content"
    t.datetime "created_at", null: false
    t.integer "model_id"
    t.string "model_type"
    t.boolean "readed", default: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "order_invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "invoice_id"
    t.integer "order_id"
    t.datetime "updated_at", null: false
  end

  create_table "order_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.float "discount", default: 1.0
    t.float "discount_price"
    t.float "discount_total_price"
    t.integer "number"
    t.integer "order_id"
    t.float "price"
    t.integer "product_id"
    t.float "total_price"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_order_products_on_deleted_at"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "applied_at"
    t.datetime "apply_at"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.float "deliver_amount"
    t.string "desc"
    t.integer "factory_id"
    t.datetime "last_deliver_at"
    t.datetime "last_payment_at"
    t.string "no"
    t.string "order_status"
    t.string "order_type"
    t.float "payment", default: 0.0
    t.integer "payment_id"
    t.float "payment_percent"
    t.integer "project_id"
    t.float "total_price"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_organizations_on_ancestry"
    t.index ["deleted_at"], name: "index_organizations_on_deleted_at"
  end

  create_table "payment_logs", force: :cascade do |t|
    t.float "amount"
    t.datetime "created_at", null: false
    t.integer "order_id"
    t.datetime "payment_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "desc"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.float "acquisition_price"
    t.string "brand"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "desc"
    t.float "freight"
    t.float "market_price"
    t.string "name"
    t.string "no"
    t.string "norms"
    t.integer "product_category_id"
    t.string "product_no"
    t.float "reference_price"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
  end

  create_table "projects", force: :cascade do |t|
    t.string "a_name"
    t.string "address"
    t.integer "agency_id"
    t.datetime "approval_time"
    t.string "butt_name"
    t.string "butt_phone"
    t.string "butt_title"
    t.string "category"
    t.integer "category_id"
    t.string "city"
    t.integer "company_id"
    t.string "constructor"
    t.string "constructor_phone"
    t.integer "contract_id"
    t.string "cost"
    t.string "cost_phone"
    t.integer "create_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.float "deliver_amount"
    t.string "design"
    t.string "design_phone"
    t.integer "estimate"
    t.string "name"
    t.float "need_payment", default: 0.0
    t.integer "owner_id"
    t.float "payment", default: 0.0
    t.float "payment_percent"
    t.string "project_status"
    t.string "purchase"
    t.string "purchase_phone"
    t.string "settling"
    t.string "settling_phone"
    t.datetime "shipment_end"
    t.integer "step", default: 0
    t.string "step_status"
    t.boolean "strategic"
    t.string "supervisor"
    t.string "supervisor_phone"
    t.string "supplier_type"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_projects_on_deleted_at"
  end

  create_table "projects_contracts", force: :cascade do |t|
    t.integer "contract_id"
    t.datetime "created_at", null: false
    t.integer "project_id"
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string "address"
    t.string "builder"
    t.datetime "created_at", null: false
    t.string "desc"
    t.string "name"
    t.string "phone"
    t.string "product"
    t.integer "project_id"
    t.string "project_step"
    t.string "project_type"
    t.string "purchase_type"
    t.string "scale"
    t.string "source"
    t.string "supply_time"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.string "target"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_resources_on_deleted_at"
  end

  create_table "role_resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "resource_id"
    t.integer "role_id"
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "desc"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "sales", force: :cascade do |t|
    t.integer "agent_id"
    t.integer "contract_id"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "desc"
    t.float "discount"
    t.float "discount_price"
    t.float "price"
    t.integer "product_id"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_sales_on_deleted_at"
  end

  create_table "sign_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id"
    t.datetime "sign_at"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "trains", force: :cascade do |t|
    t.string "action_type"
    t.datetime "created_at", null: false
    t.string "desc"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "role_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "agent_id"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "login"
    t.string "name"
    t.integer "organization_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role_id"
    t.integer "sign_in_count", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
