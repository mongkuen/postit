class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: "user_id", class_name: 'User'
  belongs_to :post
  has_many :votes, as: :voteable

  validates :body, presence: true

  def total_votes
    self.up_vote - self.down_vote
  end

  def up_vote
    self.votes.where(vote: true).size
  end

  def down_vote
    self.votes.where(vote: false).size
  end

end
