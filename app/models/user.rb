class User < ActiveRecord::Base
  # User types
  # 0: student
  # 1: instructor
  # 2: studio owner
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_type, 
    :first_name, :last_name, :address, :postal_code, :city, :phone, :privacy_id, :studio_name,
    :sanskrit_name, :last_step
  attr_protected :admin, :ambassador
  
  validates_presence_of :user_type
  validates :email, :presence => {:message => "can't be blank"},
                    :uniqueness => true,
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "has wrong format"},
                    :on => :create
  validates :first_name, :presence => true
  validates :password, :presence => true, :confirmation => true, :on => :create
  
  has_many :providers
  has_many :services
  has_one :staff_member
  has_many :area_to_users
  has_many :areas_to_ambassador, :class_name => 'AreaToUser', :conditions => {:ambassador => true}
  has_many :areas, :through => :area_to_users
  has_many :cities, :through => :areas_to_ambassador

  has_attached_file :avatar, :styles => {:small => "75x75#"}, :url => "/files/avatars/:id/:style/avatar.:extension", :path => ":rails_root/public/files/avatars/:id/:style/avatar.:extension"
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  after_create :create_staff
  has_friendly_id :name_slug, :use_slug => true

  scope :with_avatar, where("avatar_file_name != ''")
  def name_slug
    return username unless username.blank?
    [first_name, last_name].compact.join(' ')
  end

  def name is_admin = false
    privacy = is_admin ? 0 : self.privacy_id
    case privacy
    when 0, nil
      [first_name, last_name].compact.join(' ')
    when 1
      [first_name, last_name.first << '.'].compact.join(' ')
    when 2
      first_name
    end
  end

  def create_staff
    StaffMember.create(:user_id => self.id, :first_name => self.first_name, :last_name => self.last_name)
  end

  def regenerage_slugs
    task = FriendlyId::TaskRunner.new
    task.klass = 'User'
    task.delete_slugs
    task.make_slugs
  end

  def update_staff
    self.staff_member.update_attributes(:first_name => self.first_name, :last_name => self.last_name)
  end

  def self.randomly_rotate
    with_avatar.shuffle + scoped_by_avatar_file_name(nil).shuffle
  end
end
