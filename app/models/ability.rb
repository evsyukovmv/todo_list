class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    unless user.new_record?

      can :manage, Project, :user_id => user.id
      can [:read, :users, :invite, :add_user], Project do |project|
        project.users.include? user
      end

      can :manage, TaskList, :user_id => user.id
      can :manage, TaskList do |task_list|
        task_list.new_record? || task_list.project.users.include?(user)
      end

      can :manage, Task do |task|
        task.new_record? || task.task_list.user_id == user.id || task.task_list.project.users.include?(user)
      end

    end
  end
end
