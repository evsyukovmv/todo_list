class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    unless user.new_record?

      can :manage, Project, user_id: user.id

      can :manage, TaskList, user_id: user.id

      can :manage, Task do |task|
        task.new_record? || task.task_list.user_id == user.id
      end

    end
  end
end
