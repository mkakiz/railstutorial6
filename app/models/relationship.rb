class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
    # follower_id is tied to User class (user_id)
    #   without class_name, Follower class is looked up
  belongs_to :followed, class_name: "User"
    # followed_id is tied to User class (user_id)
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
