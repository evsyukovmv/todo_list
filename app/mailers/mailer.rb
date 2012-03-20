class Mailer < ActionMailer::Base
  default from: "info@todo.com"

  def invite(user, project)
    mail(:to => user.email, :subject => "You invited to the project #{project}")
  end

  def assignment(user, project, task)
    mail(:to => user.email, :subject => "You have new task #{task} of project #{project}")
  end

  def changed(user, project, task)
    mail(:to => user.email, :subject => "Your task '#{task}' of '#{project}' state was changed")
  end

end
