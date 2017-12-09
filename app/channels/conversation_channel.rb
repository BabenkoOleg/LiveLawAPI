class ConversationChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:id]

    if current_user.kind_of? User
      id = [current_user.id, user_id].sort.join('#')
      stream_from "conversations_#{id}_channel"
    else
      reject
    end
  end
end
