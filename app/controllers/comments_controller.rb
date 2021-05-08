class CommentsController < ApplicationController
  before_action :set_event, only: %i[create destroy] # TODO :update :edit
  before_action :set_comment, only: :destroy # TODO :update

  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      notify_subscribers(@event, @new_comment)
      redirect_to @event
      sweetalert_success t('comments.notice.created')
    else
      render 'events/show'
    end
  end

  # TODO
  #
  # def update
  #   if @comment.update(comment_params)
  #     sweetalert_success t('comments.notice.updated')
  #     redirect_to @comment
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    if user_can_edit?(@comment)
      @comment.destroy!
      redirect_to @event
      sweetalert_success t('comments.notice.deleted')
    else
      redirect_to @event
      # TODO: error
    end
  end

  private

  def notify_subscribers(event, comment)
    event_emails = event.subscriptions.pluck(:user_email)
    event_emails -= [@new_comment.user.email] if @new_comment.user
    event_emails += [event.user.email]

    event_emails.each do |email|
      EventMailer.comment(event, comment, email).deliver_now
    end
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end
end
