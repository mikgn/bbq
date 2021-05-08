class SubscriptionsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_subscription, only: :destroy

  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if @new_subscription.save
      EventMailer.subscription(@event, @new_subscription).deliver_now
      redirect_to @event
      sweetalert_success t('subscriptions.notice.subscribed')
    else
      render 'events/show'
    end
  end

  def destroy
    if user_can_edit?(@subscription)
      @subscription.destroy
      sweetalert_success t('subscriptions.notice.unsubscribed')
    else
      # TODO: errors
    end
    redirect_to @event
  end

  private

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
