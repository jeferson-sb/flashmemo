class NotificationMailer < ApplicationMailer
  default from: 'notifications@flashmemo.com'

  def review_email
    @user = params[:user]
    @url  = params[:url]
    mail(to: @user.email, subject: 'Hey, Review time!')
  end
end
