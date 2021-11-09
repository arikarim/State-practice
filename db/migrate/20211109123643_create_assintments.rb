class CreateAssintments < ActiveRecord::Migration[6.0]
  def change
    create_table :assintments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
