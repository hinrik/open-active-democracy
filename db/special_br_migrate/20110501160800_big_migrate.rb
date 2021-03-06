class BigMigrate < ActiveRecord::Migration
  def self.up
    drop_table :blurbs
    drop_table :branch_endorsement_charts
    drop_table :branch_endorsement_rankings
    drop_table :branch_endorsements
    drop_table :branch_user_charts
    drop_table :branch_user_rankings    
    drop_table :branches
    
    create_table "categories", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "partner_id"
    end
    
    add_column :comments, :category_id, :integer
    add_column :comments, :category_name, :string
    add_column :comments, :partner_id, :integer
    
    add_column :documents, :flags_count, :integer, :default=>0
   
    drop_table :email_templates
    
    remove_column :governments, :default_branch_id
    add_column :governments, :google_login_enabled, :boolean, :default=>false
    
    add_column :partners, :geoblocking_enabled, :boolean, :default=>false
    add_column :partners, :geoblocking_open_countries, :string, :default=>""
    add_column :partners, :default_locale, :string
    add_column :partners, :iso_country_id, :integer
    
    add_column :points, :flags_count, :integer, :default=>0
    add_column :points, :user_agent, :string, :limit=>200
    add_column :points, :ip_address, :string
    
    rename_column :priorities, :obama_status, :official_status
    rename_column :priorities, :obama_value, :official_value

    add_column :priorities, :flags_count, :integer, :default=>0
    add_column :priorities, :user_agent, :string, :limit=>200
    add_column :priorities, :category_id, :integer

    add_column :priorities, :position_endorsed_24hr, :integer
    add_column :priorities, :position_endorsed_7days, :integer
    add_column :priorities, :position_endorsed_30days, :integer
    
    add_index "priorities", ["category_id"], :name => "index_priorities_on_category_id"
    add_index "priorities", ["official_status"], :name => "index_priorities_on_official_status"
    add_index "priorities", ["official_value"], :name => "index_priorities_on_official_value"
    
    add_column :rankings, :partner_id, :integer
    
    create_table "simple_captcha_data", :force => true do |t|
      t.string   "key",        :limit => 40
      t.string   "value",      :limit => 20
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "simple_captcha_data", ["key"], :name => "index_simple_captcha_data_on_key"
  
    create_table "tag_subscriptions", :id => false, :force => true do |t|
      t.integer "user_id", :null => false
      t.integer "tag_id",  :null => false
    end
  
    add_index "tag_subscriptions", ["tag_id"], :name => "index_tag_subscriptions_on_tag_id"
    add_index "tag_subscriptions", ["user_id"], :name => "index_tag_subscriptions_on_user_id"    
    
    rename_column :tags, :obama_priority_id, :official_priority_id
    add_column :tags, :tag_type, :integer
    
    create_table "tr8n_glossary", :force => true do |t|
      t.string   "keyword"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_glossary", ["keyword"], :name => "index_tr8n_glossary_on_keyword"
  
    create_table "tr8n_ip_locations", :force => true do |t|
      t.integer  "low",        :limit => 8
      t.integer  "high",       :limit => 8
      t.string   "registry",   :limit => 20
      t.date     "assigned"
      t.string   "ctry",       :limit => 2
      t.string   "cntry",      :limit => 3
      t.string   "country",    :limit => 80
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_ip_locations", ["high"], :name => "index_tr8n_ip_locations_on_high"
    add_index "tr8n_ip_locations", ["low"], :name => "index_tr8n_ip_locations_on_low"
  
    create_table "tr8n_iso_countries", :force => true do |t|
      t.string   "code",                 :null => false
      t.string   "country_english_name", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_iso_countries", ["code"], :name => "index_tr8n_iso_countries_on_code"
  
    create_table "tr8n_iso_countries_tr8n_languages", :id => false, :force => true do |t|
      t.integer "tr8n_iso_country_id"
      t.integer "tr8n_language_id"
    end
  
    create_table "tr8n_language_case_rules", :force => true do |t|
      t.integer  "language_case_id", :null => false
      t.integer  "language_id"
      t.integer  "translator_id"
      t.text     "definition",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "position"
    end
  
    add_index "tr8n_language_case_rules", ["language_case_id"], :name => "tr8n_lcr_case_id"
    add_index "tr8n_language_case_rules", ["language_id"], :name => "tr8n_lcr_lang_id"
    add_index "tr8n_language_case_rules", ["translator_id"], :name => "tr8n_lcr_translator_id"
  
    create_table "tr8n_language_case_value_maps", :force => true do |t|
      t.string   "keyword",       :null => false
      t.integer  "language_id",   :null => false
      t.integer  "translator_id"
      t.text     "map"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "reported"
    end
  
    add_index "tr8n_language_case_value_maps", ["keyword", "language_id"], :name => "index_tr8n_language_case_value_maps_on_key_and_language_id"
    add_index "tr8n_language_case_value_maps", ["translator_id"], :name => "index_tr8n_language_case_value_maps_on_translator_id"
  
    create_table "tr8n_language_cases", :force => true do |t|
      t.integer  "language_id",   :null => false
      t.integer  "translator_id"
      t.string   "keyword"
      t.string   "latin_name"
      t.string   "native_name"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "application"
    end
  
    add_index "tr8n_language_cases", ["language_id", "keyword"], :name => "index_tr8n_language_cases_on_language_id_and_keyword"
    add_index "tr8n_language_cases", ["language_id", "translator_id"], :name => "index_tr8n_language_cases_on_language_id_and_translator_id"
    add_index "tr8n_language_cases", ["language_id"], :name => "index_tr8n_language_cases_on_language_id"
  
    create_table "tr8n_language_forum_abuse_reports", :force => true do |t|
      t.integer  "language_id",               :null => false
      t.integer  "translator_id",             :null => false
      t.integer  "language_forum_message_id", :null => false
      t.string   "reason"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_forum_abuse_reports", ["language_forum_message_id"], :name => "tr8n_forum_reports_message_id"
    add_index "tr8n_language_forum_abuse_reports", ["language_id", "translator_id"], :name => "tr8n_forum_reports_lang_id_translator_id"
    add_index "tr8n_language_forum_abuse_reports", ["language_id"], :name => "tr8n_forum_reports_lang_id"
  
    create_table "tr8n_language_forum_messages", :force => true do |t|
      t.integer  "language_id",             :null => false
      t.integer  "language_forum_topic_id", :null => false
      t.integer  "translator_id",           :null => false
      t.text     "message",                 :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_forum_messages", ["language_id", "language_forum_topic_id"], :name => "tr8n_forum_msgs_lang_id_topic_id"
    add_index "tr8n_language_forum_messages", ["language_id"], :name => "tr8n_forum_msgs_lang_id"
    add_index "tr8n_language_forum_messages", ["translator_id"], :name => "tr8n_forums_msgs_translator_id"
  
    create_table "tr8n_language_forum_topics", :force => true do |t|
      t.integer  "translator_id", :null => false
      t.integer  "language_id"
      t.text     "topic",         :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_forum_topics", ["language_id"], :name => "tr8n_forum_topics_lang_id"
    add_index "tr8n_language_forum_topics", ["translator_id"], :name => "tr8n_forum_topics_translator_id"
  
    create_table "tr8n_language_metrics", :force => true do |t|
      t.string   "type"
      t.integer  "language_id",                         :null => false
      t.date     "metric_date"
      t.integer  "user_count",           :default => 0
      t.integer  "translator_count",     :default => 0
      t.integer  "translation_count",    :default => 0
      t.integer  "key_count",            :default => 0
      t.integer  "locked_key_count",     :default => 0
      t.integer  "translated_key_count", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_metrics", ["created_at"], :name => "index_tr8n_language_metrics_on_created_at"
    add_index "tr8n_language_metrics", ["language_id"], :name => "index_tr8n_language_metrics_on_language_id"
  
    create_table "tr8n_language_rules", :force => true do |t|
      t.integer  "language_id",   :null => false
      t.integer  "translator_id"
      t.string   "type"
      t.text     "definition"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_rules", ["language_id", "translator_id"], :name => "index_tr8n_language_rules_on_language_id_and_translator_id"
    add_index "tr8n_language_rules", ["language_id"], :name => "index_tr8n_language_rules_on_language_id"
  
    create_table "tr8n_language_users", :force => true do |t|
      t.integer  "language_id",                      :null => false
      t.integer  "user_id",                          :null => false
      t.integer  "translator_id"
      t.boolean  "manager",       :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_language_users", ["created_at"], :name => "index_tr8n_language_users_on_created_at"
    add_index "tr8n_language_users", ["language_id", "translator_id"], :name => "index_tr8n_language_users_on_language_id_and_translator_id"
    add_index "tr8n_language_users", ["language_id", "user_id"], :name => "index_tr8n_language_users_on_language_id_and_user_id"
    add_index "tr8n_language_users", ["updated_at"], :name => "index_tr8n_language_users_on_updated_at"
    add_index "tr8n_language_users", ["user_id"], :name => "index_tr8n_language_users_on_user_id"
  
    create_table "tr8n_languages", :force => true do |t|
      t.string   "locale",                              :null => false
      t.string   "english_name",                        :null => false
      t.string   "native_name"
      t.boolean  "enabled"
      t.boolean  "right_to_left"
      t.integer  "completeness"
      t.integer  "fallback_language_id"
      t.text     "curse_words"
      t.integer  "featured_index",       :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "google_key"
      t.string   "facebook_key"
    end
  
    add_index "tr8n_languages", ["locale"], :name => "index_tr8n_languages_on_locale"
  
    create_table "tr8n_translation_domains", :force => true do |t|
      t.string   "name"
      t.string   "description"
      t.integer  "source_count", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translation_domains", ["name"], :name => "index_tr8n_translation_domains_on_name", :unique => true
  
    create_table "tr8n_translation_key_comments", :force => true do |t|
      t.integer  "language_id",        :null => false
      t.integer  "translation_key_id", :null => false
      t.integer  "translator_id",      :null => false
      t.text     "message",            :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translation_key_comments", ["language_id", "translation_key_id"], :name => "tr8n_tkey_msgs_lang_id_tkey_id"
    add_index "tr8n_translation_key_comments", ["language_id"], :name => "tr8n_tkey_msgs_lang_id"
    add_index "tr8n_translation_key_comments", ["translator_id"], :name => "tr8n_tkey_msgs_translator_id"
  
    create_table "tr8n_translation_key_locks", :force => true do |t|
      t.integer  "translation_key_id",                    :null => false
      t.integer  "language_id",                           :null => false
      t.integer  "translator_id"
      t.boolean  "locked",             :default => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translation_key_locks", ["translation_key_id", "language_id"], :name => "tr8n_locks_key_id_lang_id"
  
    create_table "tr8n_translation_key_sources", :force => true do |t|
      t.integer  "translation_key_id",    :null => false
      t.integer  "translation_source_id", :null => false
      t.text     "details"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translation_key_sources", ["translation_key_id"], :name => "tr8n_trans_keys_key_id"
    add_index "tr8n_translation_key_sources", ["translation_source_id"], :name => "tr8n_trans_keys_source_id"
  
    create_table "tr8n_translation_keys", :force => true do |t|
      t.string   "key",                              :null => false
      t.text     "label",                            :null => false
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "verified_at"
      t.integer  "translation_count"
      t.boolean  "admin"
      t.string   "locale"
      t.integer  "level",             :default => 0
    end
  
    add_index "tr8n_translation_keys", ["key"], :name => "index_tr8n_translation_keys_on_key", :unique => true
  
    create_table "tr8n_translation_sources", :force => true do |t|
      t.string   "source"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "translation_domain_id"
    end
  
    add_index "tr8n_translation_sources", ["source"], :name => "tr8n_sources_source"
  
    create_table "tr8n_translation_votes", :force => true do |t|
      t.integer  "translation_id", :null => false
      t.integer  "translator_id",  :null => false
      t.integer  "vote",           :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translation_votes", ["translation_id", "translator_id"], :name => "tr8n_trans_votes_trans_id_translator_id"
    add_index "tr8n_translation_votes", ["translator_id"], :name => "tr8n_trans_votes_translator_id"
  
    create_table "tr8n_translations", :force => true do |t|
      t.integer  "translation_key_id",                             :null => false
      t.integer  "language_id",                                    :null => false
      t.integer  "translator_id",                                  :null => false
      t.text     "label",                                          :null => false
      t.integer  "rank",                            :default => 0
      t.integer  "approved_by_id",     :limit => 8
      t.text     "rules"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translations", ["created_at"], :name => "tr8n_trans_created_at"
    add_index "tr8n_translations", ["translation_key_id", "translator_id", "language_id"], :name => "tr8n_trans_key_id_translator_id_lang_id"
    add_index "tr8n_translations", ["translator_id"], :name => "r8n_trans_translator_id"
  
    create_table "tr8n_translator_following", :force => true do |t|
      t.integer  "translator_id"
      t.integer  "object_id"
      t.string   "object_type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translator_following", ["translator_id"], :name => "index_tr8n_translator_following_on_translator_id"
  
    create_table "tr8n_translator_logs", :force => true do |t|
      t.integer  "translator_id"
      t.integer  "user_id",       :limit => 8
      t.string   "action"
      t.integer  "action_level"
      t.string   "reason"
      t.string   "reference"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translator_logs", ["created_at"], :name => "index_tr8n_translator_logs_on_created_at"
    add_index "tr8n_translator_logs", ["translator_id"], :name => "index_tr8n_translator_logs_on_translator_id"
    add_index "tr8n_translator_logs", ["user_id"], :name => "index_tr8n_translator_logs_on_user_id"
  
    create_table "tr8n_translator_metrics", :force => true do |t|
      t.integer  "translator_id",                                     :null => false
      t.integer  "language_id",           :limit => 8
      t.integer  "total_translations",                 :default => 0
      t.integer  "total_votes",                        :default => 0
      t.integer  "positive_votes",                     :default => 0
      t.integer  "negative_votes",                     :default => 0
      t.integer  "accepted_translations",              :default => 0
      t.integer  "rejected_translations",              :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translator_metrics", ["created_at"], :name => "index_tr8n_translator_metrics_on_created_at"
    add_index "tr8n_translator_metrics", ["translator_id", "language_id"], :name => "index_tr8n_translator_metrics_on_translator_id_and_language_id"
    add_index "tr8n_translator_metrics", ["translator_id"], :name => "index_tr8n_translator_metrics_on_translator_id"
  
    create_table "tr8n_translator_reports", :force => true do |t|
      t.integer  "translator_id"
      t.string   "state"
      t.integer  "object_id"
      t.string   "object_type"
      t.string   "reason"
      t.text     "comment"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "tr8n_translator_reports", ["translator_id"], :name => "index_tr8n_translator_reports_on_translator_id"
  
    create_table "tr8n_translators", :force => true do |t|
      t.integer  "user_id",                                 :null => false
      t.boolean  "inline_mode",          :default => false
      t.boolean  "blocked",              :default => false
      t.boolean  "reported",             :default => false
      t.integer  "fallback_language_id"
      t.integer  "rank",                 :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
      t.string   "gender"
      t.string   "email"
      t.string   "password"
      t.string   "mugshot"
      t.string   "link"
      t.string   "locale"
      t.integer  "level",                :default => 0
      t.boolean  "manager"
      t.string   "last_ip"
      t.string   "country_code"
    end
  
    add_index "tr8n_translators", ["created_at"], :name => "index_tr8n_translators_on_created_at"
    add_index "tr8n_translators", ["email", "password"], :name => "index_tr8n_translators_on_email_and_password"
    add_index "tr8n_translators", ["email"], :name => "index_tr8n_translators_on_email"
    add_index "tr8n_translators", ["user_id"], :name => "index_tr8n_translators_on_user_id"
    
    remove_column :users, :branch_id
    remove_column :users, :branch_position
    remove_column :users, :branch_position_24hr
    remove_column :users, :branch_position_7days
    remove_column :users, :branch_position_30days
    remove_column :users, :branch_position_24hr_change
    remove_column :users, :branch_position_7days_change
    remove_column :users, :branch_position_30days_change
    remove_column :users, :is_branch_chosen
        
    add_column :users, :facebook_id, :integer
    add_column :users, :reports_enabled, :boolean, :default=>false
    add_column :users, :reports_discussions, :boolean, :default=>false
    add_column :users, :reports_documents, :boolean, :default=>false
    add_column :users, :reports_interval, :integer
    add_column :users, :last_sent_report, :datetime
    add_column :users, :geoblocking_open_countries, :string, :default=>""
    add_column :users, :identifier_url, :string
    
    add_index "users", ["identifier_url"], :name => "index_users_on_identifier_url", :unique => true

    create_table "wf_filters", :force => true do |t|
      t.string   "type"
      t.string   "name"
      t.text     "data"
      t.integer  "user_id"
      t.string   "model_class_name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    add_index "wf_filters", ["user_id"], :name => "index_wf_filters_on_user_id"        
  end

  def self.down
  end
end
