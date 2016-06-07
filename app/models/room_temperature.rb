class RoomTemperature < ActiveRecord::Base
  # Associations
  has_many :rooms, :foreign_key => :temperature_id

  # Validations
  validates :name, :presence => true

  class << self
    # Convenience method.
    #
    # RoomTemperature['Hot'] == RoomTemperature.find_by_name('Hot')
    def [](name)
      find_by_name(name)
    end
  end

  def self.order_temp
    options = all
    array = []
    array[0], array[1] = options[1], options[0]
    array[2..-1] = options[2..-1]
    array
  end
end
