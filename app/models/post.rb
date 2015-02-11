class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: {minimum: 5}
  validates :description, presence: true
  validates :url, presence: true

  before_save :save_slug

  def total_votes
    self.up_votes - self.down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug(string)
    string.strip.downcase.gsub(' ', '-').gsub(/[^0-9a-z-]/, '')
  end

  def save_slug
    initial_slug = generate_slug(self.title)
    if Post.find_by(slug: initial_slug)
      while Post.find_by(slug: initial_slug)
        count = initial_slug[-1].to_i + 1
        if initial_slug[-1].to_i == 0
          initial_slug = initial_slug + count.to_s
        else
          initial_slug = initial_slug[0...-1] + count.to_s
        end
      end
      self.slug = initial_slug
    else
      self.slug = initial_slug
    end
  end

  def to_param
    self.slug
  end

end
