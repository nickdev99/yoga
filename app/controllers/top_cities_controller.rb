class TopCitiesController < ApplicationController
  def index
    @data = Area.where(:active => true).map { |area|
      p area.city
      {:city => area,
        :instructors => area.users.count,
        :studios => {
          :studio => area.studios.count,
          :course => area.courses.where('event_type = "recurring"').count
          }
      }
    }
    @data = @data.sort_by {|d| d[:instructors]}.reverse
  end
end
