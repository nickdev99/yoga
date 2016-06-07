# Represents a place where yoga classes happen.
#
# One studio belongs to one provider; one provider can have one or more studios
# (this lets us handle larger groups of studios, all owned by one business, as well
# as single independent studios).
class Studio < ActiveRecord::Base
  has_friendly_id :name_slug, :use_slug => true
  # Associations
  belongs_to :provider
  has_many   :courses
  has_many   :rooms
  has_many :details
  belongs_to :area
  has_and_belongs_to_many :users

  validates :name, :presence => true
  validates :address, :presence => true
  validates :area_id, :presence => true

  def courses_on(date)
    courses.select { |c| c.occurrs_on?(date) }
  end

  def name_slug
    return "#{address}" if !address.blank? && self.provider.studios.count
    "#{self.name}"
  end

  def self.search(q)
    where("name LIKE ?", "%#{q}%")
  end

  def regenerage_slugs
    task = FriendlyId::TaskRunner.new
    task.klass = 'Studio'
    task.delete_slugs
    task.make_slugs
  end
end
