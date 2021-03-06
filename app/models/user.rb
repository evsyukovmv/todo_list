class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :task_lists, :dependent => :destroy
  #has_many :projects, :dependent => :destroy
  has_many :tasks, :foreign_key => :performer_id
  has_many :relationships

  def projects
    (relationships.map(&:project) | Project.where(:user_id => id)).compact
  end



end
