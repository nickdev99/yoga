class AreaToUser < ActiveRecord::Base
  belongs_to :area
  belongs_to :user
  belongs_to :cities, :class_name => 'Area', :foreign_key => :area_id
end
