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

require 'spec_helper'

describe Task do
  pending "add some examples to (or delete) #{__FILE__}"
end
