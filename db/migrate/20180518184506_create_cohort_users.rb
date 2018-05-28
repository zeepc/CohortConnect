class CreateCohortUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :cohort_users do |t|
      t.integer :cohort_id
      t.integer :user_id
      t.string :user_role, default: 'student'

      t.timestamps
    end
  end
end
