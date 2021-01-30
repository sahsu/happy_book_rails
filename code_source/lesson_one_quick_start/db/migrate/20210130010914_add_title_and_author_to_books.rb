# 对应<<Model2 增删改查>>
# 本文件为books表增加内容
class AddTitleAndAuthorToBooks < ActiveRecord::Migration

  def up

    # 增加列：标题
    add_column :books, :title, :string

    # 增加列：作者
    add_column :books, :author, :string
  end

  def down

    # 删除列 books 表中的title
    remove_column :books, :title

    # 删除列 books 表中的author
    remove_column :books, :author
  end
end
