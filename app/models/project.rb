class Project < ActiveRecord::Base
  attr_accessible :name, :description, :user_id

  validates :name, presence: true

  belongs_to :user
  has_many :task_lists, :dependent => :destroy

end
