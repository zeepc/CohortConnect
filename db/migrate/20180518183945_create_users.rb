class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :profile_image_url
      t.string :profile_link_url
      t.string :current_employer
      t.string :current_title
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
