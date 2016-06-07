class Area < ActiveRecord::Base
  validates :city, :presence => true
  validates :region, :presence => true
  validates :region_abbr, :presence => true
  validates :country, :presence => true
  validates :country_code, :presence => true
  has_many :studios
  has_many :area_to_users
  has_many :users, :through => :area_to_users
  has_many :courses, :through => :studios

  def city_cached_slug
    city
  end

  def city_cached_slug=(value)
    self.city = value
    self.city_slug = value.downcase.gsub(/[^a-z1-9]+/, '-').chomp('-')
  end

  def region_abbreviature
    self.region_abbr
  end

  def region_abbreviature=(value)
    self.region_abbr = value.downcase
  end
end
