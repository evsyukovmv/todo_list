Factory.define :user do |user|
  user.email "user@example.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.define :project do |project|
  project.name "Example project"
  project.description "Description"
end

Factory.define :task_list do |task_list|
  task_list.name "Example task_list"
  task_list.description "Description"
end

Factory.define :task do |task|
  task.name "Example task"
  task.description "Description"
  task.state "not_done"
  task.priority 1
end