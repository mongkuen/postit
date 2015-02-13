module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :save_slug
    class_attribute :slug_column
  end

  def generate_slug(string)
    string.strip.downcase.gsub(' ', '-').gsub(/[^0-9a-z-]/, '')
  end

  def to_param
    self.slug
  end

  def save_slug
    initial_slug = generate_slug(self.send(self.class.slug_column.to_sym))
    if self.class.find_by(slug: initial_slug)
      while self.class.find_by(slug: initial_slug)
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

  module ClassMethods
    def sluggable_column(column_name)
      self.slug_column = column_name.to_s
    end
  end

end
