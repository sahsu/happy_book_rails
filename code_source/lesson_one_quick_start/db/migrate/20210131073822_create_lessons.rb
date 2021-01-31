class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.integer :teacher_id
      t.integer :student_id
    end
  end
end
