class CreateCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :commits do |t|
      t.string :owner
      t.string :repo
      t.string :author
      t.string :date
      t.text :info

      t.timestamps
    end
  end
end
