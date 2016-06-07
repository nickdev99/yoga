class Notifier < ActionMailer::Base
  default :from => "vitaliyk@interlink-ua.com"

  def registration inviter, user, password
    @inviter = inviter
    @user = user
    @password = password
    mail(:to => @user.email, :subject => "(ILY) #{inviter.name} has added you to I Live Yoga - Find out more inside")
  end

  def send_invitation inviter, message, email, area
    @inviter = inviter
    @message =  message
    @area = area
    mail(:to => email, :subject => "#{inviter.name(true)} has invited you to I Live Yoga - Find out more inside")
  end

  def signup user
    @user = user
    mail(:to => user.email, :subject => "Welcome to I Live Yoga!")
  end
end
