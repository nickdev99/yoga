class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @studios = Provider.joins(:studios).where("studios.studio_type = 'studio' and area_id = ?", @area.id).uniq
    @non_studios = Provider.joins(:studios).where("studios.studio_type = 'non-studio' and area_id = ?", @area.id).uniq
    @other_providers = Provider.all.select{|prov| prov.studios.blank? == true}
    @stores = Provider.joins(:studios).where("studios.studio_type = 'store' and area_id = ?", @area.id).uniq
    @users = User.count
    @instructors = User.where(:is_yoga_teacher => true).count
  end
end
