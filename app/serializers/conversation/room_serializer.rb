class Conversation::RoomSerializer < ActiveModel::Serializer
  attributes :id
  has_many :messages, if: -> { should_render_messages }

  def should_render_messages
    @instance_options[:messages]
  end
end
