class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"

    if current_user.kind_of? User
      message = { user_id: current_user.id, online: :on }
      ActionCable.server.broadcast('appearance_channel', message)
      current_user.update(online: true)
    else
      reject
    end
  end

  def unsubscribed
    if current_user.kind_of? User
      message = { user_id: current_user.id, online: :off }
      ActionCable.server.broadcast('appearance_channel', message)
      current_user.update(online: false)
    end
  end
end
