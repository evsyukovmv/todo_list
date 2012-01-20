class Project < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :user
  has_many :task_lists, :dependent => :destroy
end
