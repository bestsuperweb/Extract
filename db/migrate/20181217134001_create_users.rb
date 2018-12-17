class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first
      t.string :last
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
