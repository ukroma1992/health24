class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.datetime :date
      t.references :user, foreign_key: true
      t.string :sha_hash
      t.string :description

      t.timestamps
    end
  end
end
