class Project < ActiveRecord::Base
  belongs_to :user
  has_many :task_lists
end
