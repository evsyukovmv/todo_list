# == Schema Information
#
# Table name: task_lists
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class TaskList < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :task
end
