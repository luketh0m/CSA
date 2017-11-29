class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, class_name: "Post", foreign_key: "comment_id", dependent: :destroy
  belongs_to :comment, class_name: "Post", optional: true

end
