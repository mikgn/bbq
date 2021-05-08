module ApplicationHelper
  def user_avatar(user)
    if user.present? && user.avatar?
      user.avatar.url
    else
      asset_path('sample_avatar.jpg')
    end
  end
end
