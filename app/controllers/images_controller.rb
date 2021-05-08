class ImagesController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_image, only: :destroy

  def create
    @new_image = @event.images.build(image_params)
    @new_image.user = current_user

    if @new_image.save
      notify_subscribers(@new_image.event, @new_image)
      redirect_to @event
      sweetalert_success t('events.notice.image_added')
    else
      render 'events/show'
    end
  end

  def destroy
    if user_can_edit?(@image)
      @image.destroy
      sweetalert_success t('events.notice.image_deleted')
    end
    redirect_to @event
  end

  private

  def notify_subscribers(event, image)
    event_emails = event.subscriptions.pluck(:user_email) - [@new_image.user.email] + [event.user.email]

    event_emails.each do |email|
      EventMailer.image(event, image, email).deliver_now
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.fetch(:image, {}).permit(:image)
  end
end
