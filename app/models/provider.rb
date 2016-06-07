# Represents an organisation providing yoga classes.
#
# Note that a Provider is not the same as a Studio: a Provider
# is an organisation (business etc) which may have one or many Studios;
# a Studio is the place where classes happen.
class Provider < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  # Associations
  has_many :studios
  has_many :courses, :through => :studios
  has_and_belongs_to_many :staff_members

  belongs_to :user

  # Validations
  validates :name, :presence => true, :uniqueness => true

  def formated_featured_date
    featured_date.strftime("%m/%d/%Y") if featured_date
  end

  def formated_featured_date=(value)
    self.featured_date = value
  end
end
