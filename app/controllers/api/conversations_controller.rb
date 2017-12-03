class Api::ConversationsController < ApplicationController
  before_action :authenticate_api_user!

  def index
    dialogs = Conversation::Dialog.json_for_index(current_api_user)
    render json: dialogs
  end
end
