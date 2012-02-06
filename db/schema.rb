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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120205000024) do

  create_table "atividades", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.integer  "versiculo_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "biblia", :force => true do |t|
    t.string  "nome",                            :null => false
    t.string  "permalink",                       :null => false
    t.integer "secoes_count",     :default => 0, :null => false
    t.integer "livros_count",     :default => 0, :null => false
    t.integer "capitulos_count",  :default => 0, :null => false
    t.integer "versiculos_count", :default => 0, :null => false
  end

  create_table "capitulos", :force => true do |t|
    t.integer "numero",                           :null => false
    t.integer "biblia_id",                        :null => false
    t.integer "secao_id",                         :null => false
    t.integer "livro_id",                         :null => false
    t.integer "versiculos_count",  :default => 0, :null => false
    t.integer "comentarios_count", :default => 0, :null => false
  end

  add_index "capitulos", ["biblia_id"], :name => "index_capitulos_on_biblia_id"
  add_index "capitulos", ["livro_id"], :name => "index_capitulos_on_livro_id"
  add_index "capitulos", ["secao_id"], :name => "index_capitulos_on_secao_id"

  create_table "comentarios", :force => true do |t|
    t.string   "href",              :null => false
    t.string   "comment_id",        :null => false
    t.integer  "parent_comment_id"
    t.integer  "livro_id"
    t.integer  "capitulo_id"
    t.integer  "versiculo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comentarios", ["capitulo_id"], :name => "index_comentarios_on_capitulo_id"
  add_index "comentarios", ["comment_id"], :name => "index_comentarios_on_comment_id", :unique => true
  add_index "comentarios", ["livro_id"], :name => "index_comentarios_on_livro_id"
  add_index "comentarios", ["parent_comment_id"], :name => "index_comentarios_on_parent_comment_id"
  add_index "comentarios", ["versiculo_id"], :name => "index_comentarios_on_versiculo_id"

  create_table "comments", :force => true do |t|
    t.text     "texto"
    t.integer  "user_id"
    t.integer  "versiculo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "texto_html"
    t.integer  "item_id"
    t.string   "item_type"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "links", :force => true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "versiculo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "titulo"
  end

  create_table "livros", :force => true do |t|
    t.integer "numero",                           :null => false
    t.string  "nome",                             :null => false
    t.string  "permalink",                        :null => false
    t.integer "biblia_id",                        :null => false
    t.integer "secao_id",                         :null => false
    t.integer "capitulos_count",   :default => 0, :null => false
    t.integer "versiculos_count",  :default => 0, :null => false
    t.integer "comentarios_count", :default => 0, :null => false
  end

  add_index "livros", ["biblia_id"], :name => "index_livros_on_biblia_id"
  add_index "livros", ["numero"], :name => "index_livros_on_numero"
  add_index "livros", ["secao_id"], :name => "index_livros_on_secao_id"

  create_table "referencias", :force => true do |t|
    t.string   "ref"
    t.integer  "user_id"
    t.integer  "versiculo_id"
    t.integer  "versiculo_citado_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "secoes", :force => true do |t|
    t.string  "nome",                            :null => false
    t.string  "permalink",                       :null => false
    t.integer "biblia_id",                       :null => false
    t.integer "livros_count",     :default => 0, :null => false
    t.integer "capitulos_count",  :default => 0, :null => false
    t.integer "versiculos_count", :default => 0, :null => false
  end

  add_index "secoes", ["biblia_id"], :name => "index_secoes_on_biblia_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versiculos", :force => true do |t|
    t.integer  "numero",                           :null => false
    t.text     "texto"
    t.integer  "biblia_id",                        :null => false
    t.integer  "secao_id",                         :null => false
    t.integer  "livro_id",                         :null => false
    t.integer  "capitulo_id",                      :null => false
    t.integer  "comentarios_count", :default => 0, :null => false
    t.datetime "last_comment_at"
    t.integer  "comments_count",    :default => 0, :null => false
    t.integer  "referencias_count", :default => 0, :null => false
    t.integer  "links_count",       :default => 0, :null => false
    t.integer  "videos_count",      :default => 0, :null => false
    t.integer  "atividades_count",  :default => 0, :null => false
    t.integer  "citacoes_count",    :default => 0, :null => false
  end

  add_index "versiculos", ["biblia_id"], :name => "index_versiculos_on_biblia_id"
  add_index "versiculos", ["capitulo_id"], :name => "index_versiculos_on_capitulo_id"
  add_index "versiculos", ["livro_id"], :name => "index_versiculos_on_livro_id"
  add_index "versiculos", ["secao_id"], :name => "index_versiculos_on_secao_id"

  create_table "videos", :force => true do |t|
    t.string   "thumb_url"
    t.string   "link_url"
    t.string   "player_url"
    t.string   "titulo"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "versiculo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
