class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 8}

  before_save :save_slug

  def generate_slug(string)
    string.strip.downcase.gsub(' ', '-').gsub(/[^0-9a-z-]/, '')
  end

  def save_slug
    initial_slug = generate_slug(self.username)
    if User.find_by(slug: initial_slug)
      while User.find_by(slug: initial_slug)
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
