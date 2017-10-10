class ChatSerializer < ActiveModel::Serializer
  attributes :id, :question
  has_many :chat_messages
end
