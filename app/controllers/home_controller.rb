class HomeController < ApplicationController
  
  def index
    @styles = CourseStyle.all.select { |s| !s.courses.blank? }.sort_by { |st| st.courses.count }.reverse
    @styles = @styles[0..19] if params[:style_id] == 'show-all'
    if params[:style_id] && params[:style_id] != 'show-all'
      if params[:style_id] == 'yoga-for-beginners'
        if current_user && (is_ambassador? || current_user.is_yoga_teacher || current_user.user_type == 2)
          @providers = Provider.joins({:studios => {:courses => :experience_levels}}).where('(experience_levels.name = "Beginner" or experience_levels.name = "Any") and studios.area_id = ? and (is_featured = "t" and (featured_date > "' + Date.today.to_s + '" or featured_date IS NULL))', @area.id).order('random()')
          @providers += Provider.joins({:studios => {:courses => :experience_levels}}).where('(experience_levels.name = "Beginner" or experience_levels.name = "Any") and studios.area_id = ?', @area.id).order('random()')
        else
          @providers = Provider.joins({:studios => {:courses => :experience_levels}}).where('studios.studio_type = "studio" and (experience_levels.name = "Beginner" or experience_levels.name = "Any") and studios.area_id = ? and (is_featured = "t" and (featured_date > "' + Date.today.to_s + '" or featured_date IS NULL))', @area.id).order('random()')
          @providers += Provider.joins({:studios => {:courses => :experience_levels}}).where('studios.studio_type = "studio" and (experience_levels.name = "Beginner" or experience_levels.name = "Any") and studios.area_id = ?', @area.id).order('random()')
        end
        @providers.uniq_by!(&:id)
        @title = "I Live Yoga - #{@city.capitalize} :: All Studios. All Classes."
      else
        @style = CourseStyle.find(params[:style_id])
        @providers = Course.joins([:styles, :studio]).where("studios.area_id = ? and course_styles.cached_slug == ?", @area.id, params[:style_id]).order('random()')
        @providers = @providers.where('studios.studio_type = "studio"') if !current_user || !is_ambassador? || !current_user.is_yoga_teacher || !current_user.user_type == 2
        @providers = @providers.group_by { |c| c.studio.provider }.collect{|p, c| p}
        @providers = @providers.select {|p, c| p.is_featured && (p.featured_date.nil? || p.featured_date > Date.today)}.sort_by { rand } + @providers
        @providers.uniq_by!(&:id)
        @title = "#{@style.name} Classes #{@city.capitalize} :: I Live Yoga - All Studios. All Classes."
      end
    else
      if current_user && (is_ambassador? || current_user.is_yoga_teacher || current_user.user_type == 2)
        @providers = Provider.joins(:studios).where('studios.area_id = ? and (is_featured = "t" and (featured_date > "' + Date.today.to_s + '" or featured_date IS NULL))', @area.id).order('random()')
        @providers += Provider.joins(:studios).where('studios.area_id = ?', @area.id).order('random()')
      else
        @providers = Provider.joins(:studios).where('studios.studio_type = "studio" and studios.area_id = ? and (is_featured = "t" and (featured_date > "' + Date.today.to_s + '" or featured_date IS NULL))', @area.id).order('random()')
        @providers += Provider.joins(:studios).where('studios.studio_type = "studio" and studios.area_id = ?', @area.id).order('random()')
      end
      @providers.uniq_by!(&:id)
      @title = "I Live Yoga - #{@city.capitalize} :: All Studios. All Classes."
    end
  end
end
