class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, uniqueness: true
  before_save :save_slug

  def generate_slug(string)
    string.strip.downcase.gsub(' ', '-').gsub(/[^0-9a-z-]/, '')
  end

  def save_slug
    initial_slug = generate_slug(self.name)
    if Category.find_by(slug: initial_slug)
      while Category.find_by(slug: initial_slug)
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
