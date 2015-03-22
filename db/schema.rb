# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150219033850) do

  create_table "amino_acids", force: true do |t|
    t.string   "amino_acid_symbol"
    t.string   "amino_acid_letter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codons", force: true do |t|
    t.string   "symbol"
    t.string   "amino_acid_symbol"
    t.string   "amino_acid_letter"
    t.integer  "amino_acid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ds_output_genes", force: true do |t|
    t.integer  "gene_id"
    t.integer  "ds_output_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ds_output_genes", ["gene_id", "ds_output_id"], name: "index_ds_output_genes_on_gene_id_and_ds_output_id"

  create_table "ds_outputs", force: true do |t|
    t.string   "sequence"
    t.string   "loop_plus_two"
    t.string   "loop_plus_one"
    t.string   "loop_seq"
    t.integer  "loop_start_position"
    t.integer  "strength"
    t.string   "site_type"
    t.integer  "r_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feature_id"
    t.integer  "genome_id"
    t.integer  "human_gene_id"
  end

  create_table "features", force: true do |t|
    t.integer  "start_position"
    t.integer  "end_position"
    t.string   "strand"
    t.string   "feature_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gene_id"
    t.string   "first_third"
    t.string   "half"
    t.string   "second_third"
  end

  create_table "genes", force: true do |t|
    t.string   "name"
    t.integer  "start_position"
    t.integer  "end_position"
    t.string   "strand"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hypothetical"
    t.integer  "genome_id"
    t.boolean  "pseudo_gene"
    t.string   "first_third"
    t.string   "half"
    t.string   "second_third"
  end

  create_table "genomes", force: true do |t|
    t.string   "name"
    t.string   "kingdom"
    t.string   "genome_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "human_features", force: true do |t|
    t.integer  "start_position"
    t.integer  "stop_position"
    t.string   "gene_symbol"
    t.string   "refseq_transcript_name"
    t.integer  "strand"
    t.integer  "refseq_exon_position"
    t.integer  "coding_start"
    t.integer  "coding_stop"
    t.integer  "human_transcript_id"
    t.boolean  "canonical"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "human_genes", force: true do |t|
    t.integer  "old_id"
    t.string   "symbol"
    t.integer  "start_position"
    t.integer  "stop_position"
    t.integer  "strand"
    t.integer  "chromosome_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "human_transcripts", force: true do |t|
    t.string   "refseq_transcript_name"
    t.integer  "chromosome_id"
    t.integer  "strand"
    t.integer  "start_position"
    t.integer  "stop_position"
    t.integer  "coding_start"
    t.integer  "coding_stop"
    t.string   "symbol"
    t.integer  "human_gene_id"
    t.boolean  "canonical"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", force: true do |t|
    t.string   "sequence"
    t.string   "loop_plus_two"
    t.string   "loop_plus_one"
    t.string   "loop_seq"
    t.string   "strand"
    t.integer  "loop_start_position"
    t.integer  "start_position"
    t.integer  "end_position"
    t.integer  "strength"
    t.string   "type"
    t.integer  "r_value"
    t.integer  "c_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ds_output_id"
    t.integer  "genome_id"
    t.string   "hb_codon"
  end

  create_table "stem_loops", force: true do |t|
    t.integer  "loop_start_position"
    t.string   "strand"
    t.integer  "r_value"
    t.integer  "gene_id"
    t.integer  "feature_id"
    t.string   "genome_id"
    t.integer  "strength"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
