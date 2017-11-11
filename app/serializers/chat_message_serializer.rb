class ChatMessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :sender_id, :sender_role, :created_at
end
