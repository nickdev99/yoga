class StaffMember < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :providers
  has_many   :assignments
  has_many   :courses, :through => :assignments
  belongs_to :user
  has_one :staff_member
  has_many :roles
  has_and_belongs_to_many :studios
  
  # Validations
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  
  def name is_admin = false
    self.user.privacy_id
    privacy = is_admin ? 0 : self.user.privacy_id
    case privacy
    when 0, nil
      [first_name, last_name].compact.join(' ')
    when 1
      [first_name, last_name.first << '.'].compact.join(' ')
    when 2
      first_name
    end
  end
end
