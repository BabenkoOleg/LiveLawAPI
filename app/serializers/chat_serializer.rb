class ChatSerializer < ActiveModel::Serializer
  attributes :id
  has_many :chat_messages
end
