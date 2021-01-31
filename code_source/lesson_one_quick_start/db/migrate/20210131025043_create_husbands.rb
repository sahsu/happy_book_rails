class CreateHusbands < ActiveRecord::Migration
  def change
    create_table :husbands do |t|
      t.string :name
    end
  end
end
