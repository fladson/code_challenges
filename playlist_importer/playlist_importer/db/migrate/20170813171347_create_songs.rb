class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :interpret
      t.string :album
      t.string :track
      t.string :year
      t.string :genre

      t.timestamps
    end
  end
end
