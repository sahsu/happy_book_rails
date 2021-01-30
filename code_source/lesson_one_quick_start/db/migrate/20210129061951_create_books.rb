# <<model 基础1： 数据库迁移>>的演示代码
#
# 本文件的作用是创建一个 migration
class CreateBooks < ActiveRecord::Migration
  # 新建表 books
  def up
    create_table :books do |t|
      # 创建了一个列name, 类型是varchar
      t.string :name
    end
  end

  # 删除表 books
  def down
    drop_table :books
  end

  # 上面的 up 和 down方法，等同于下面一个方法
  #def change
  #  create_table :books do |t|
  #    t.string :name
  #  end
  #end

end
