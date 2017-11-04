class ChatSerializer < ActiveModel::Serializer
  attributes :id, :question
  attribute :token, if: -> { should_render_chat_token }
  has_many :chat_messages
end

def should_render_chat_token
  @instance_options[:chat_token]
end
