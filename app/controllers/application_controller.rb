class ApplicationController < ActionController::Base
  helper_method :user_can_edit?
  helper_method :user_can_subscribe?

  def configure_permitted_parameters
    attrs = %i[name email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: attrs
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end

  def user_can_edit?(model)
    return unless user_signed_in?

    model.user == current_user ||
      model.try(:event).present? && model.event.user == current_user
  end

  def user_can_subscribe?(event)
    event.subscribers.exclude?(current_user) &&
      event.user != current_user
  end
end
