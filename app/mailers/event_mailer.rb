class EventMailer < ApplicationMailer
  # en.event_mailer.subscription.subject
  def subscription(event, subscription)
    @email = subscription.user_email
    @name = subscription.user_name
    @event = event

    mail to: event.user.email, subject: "#{t('event_mailer.subscription.subject')} #{event.title}"
  end
  # en.event_mailer.comment.subject
  def comment(event, comment, email)
    @event = event
    @comment = comment

    mail to: email, subject: "#{t('event_mailer.comment.subject')} #{event.title}"
  end

  def image(event, image, email)
    @event = event
    @image = image

    mail to: email, subject: "#{image.user.name} #{t('event_mailer.image.subject')} #{event.title}"
  end
end
