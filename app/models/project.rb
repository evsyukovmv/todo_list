class Project < ActiveRecord::Base
  attr_accessible :name, :description, :user_id

  validates :name, presence: true

  belongs_to :user
  has_many :task_lists, :dependent => :destroy
  has_many :relationships

  def users
    (relationships.map(&:user) | User.where(id: user_id)).compact
  end
end
