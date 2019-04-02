class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages, options: 'ROW_FORMAT=DYNAMIC' do |t|
      t.references :user, null: false
      t.string :url_token, null: false, unique: true
      t.text :text, null: false
      t.string :image
      t.boolean :is_public, null: false, default: 0
      t.timestamps
    end
  end
end
