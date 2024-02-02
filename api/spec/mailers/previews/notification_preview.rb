class NotificationPreview < ActionMailer::Preview
  def review_email
    NotificationMailer.with(user: User.first, url: 'http://localhost:3000/api/revisions/1.json').review_email
  end
end
