require 'digest/sha1'

# The common User model.
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.act_like_restful_authentication = true
    # c.session_class = Session
    # c.find_by_login_method :find_by_username_or_email
  end
  
  def self.find_by_username_or_email(login)
    find_by_username(login) || find_by_email(login)
  end
  
  has_many :work_hours
  has_many :duties# , :extend => FindByAssociatedExtension
  has_many :projects, :through => :duties
  has_many :roles, :through => :duties# , :extend => FindByAssociatedExtension
  has_many :commitments

  scope :enabled, :conditions => {:disabled => false}

  validates_presence_of     :login, :email, :real_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :destroy_all_duties, :if => :disabled

  validates_numericality_of :available_hours_per_week, :positive => true, :greater_than_or_equal_to => 0

  attr_accessible :login, :password, :password_confirmation, :real_name, :email, :available_hours_per_week, :disabled

  alias_attribute :name, :real_name
  
  def password_required?
    crypted_password.blank? || !password.blank?
  end
  
  def projects_to_show
    Project.for_user(self)
  end

  def authorized_for_update?
    current_user.admin? || current_user == self
  end

  def disabled_authorized_for_update?
    current_user != self
  end

  def admin_authorized_for_update?
    current_user != self
  end

  def authorized_for_destroy?
    current_user.admin? and current_user != self and !self.disabled?
  end

  def role_for_project p
    roles.with_project(p).first
  end

  def duty_for_project p
    duties.with_project(p).first
  end

  protected
    def destroy_all_duties
      duties.each(&:destroy)
    end
end
