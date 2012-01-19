# == Schema Information
#
# Table name: tasks
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  description  :text
#  state        :boolean         default(FALSE)
#  priority     :integer         default(0)
#  task_list_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Task < ActiveRecord::Base
  attr_accessible :name, :description, :state, :priority

  symbolize :state, :in => [:"Not done", :"In process", "Done"], :scopes => true, :i18n => false

  belongs_to :task_list
end
