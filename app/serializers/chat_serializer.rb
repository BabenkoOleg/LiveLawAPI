class ChatSerializer < ActiveModel::Serializer
  attributes :id, :question, :status, :invited_at, :city, :category
  attribute :token, if: -> { should_render_chat_token }
  has_many :chat_messages

  def should_render_chat_token
    @instance_options[:chat_token]
  end

  [:city, :category].each do |meth|
    define_method(meth) { object.send(meth).name }
  end
end
