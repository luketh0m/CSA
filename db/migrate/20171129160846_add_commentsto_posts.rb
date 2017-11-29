class AddCommentstoPosts < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :comment, index: true
  end
end
