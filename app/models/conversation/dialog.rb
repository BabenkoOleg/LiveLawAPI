# == Schema Information
#
# Table name: conversation_dialogs
#
#  id        :integer          not null, primary key
#  user_1_id :integer
#  user_2_id :integer
#
# Indexes
#
#  index_conversation_dialogs_on_user_1_id  (user_1_id)
#  index_conversation_dialogs_on_user_2_id  (user_2_id)
#

class Conversation::Dialog < ApplicationRecord
  # Relations ------------------------------------------------------------------

  has_many :messages, class_name: 'Conversation::Message', dependent: :destroy

  # Methods --------------------------------------------------------------------

  class << self
    def json_for_index(user)
      dialogs = dialogs_for_user(user)

      set_totals(dialogs)
      set_unreads(dialogs, user)
      set_users(dialogs)
      set_last_messages(dialogs)

      { dialogs: dialogs.values }
    end

    def common(user_1, user_2)
      dialog = find_by('user_1_id = ? and user_2_id = ?', user_1.id, user_2.id)
      dialog ||= find_by('user_1_id = ? and user_2_id = ?', user_2.id, user_1.id)
      dialog.present? ? dialog : create(user_1_id: user_1.id, user_2_id: user_1.id)
    end

    private

    def dialogs_for_user(user)
      dialogs = where('user_1_id = ? or user_2_id = ?', user.id, user.id)
      data = {}
      dialogs.map do |item|
        user_id = user.id == item.user_1_id ? item.user_2_id : item.user_1_id
        data[item.id] = { user_id: user_id }
      end
      data
    end

    def set_users(dialogs)
      users = {}
      User.where(id: dialogs.values.pluck(:user_id)).map do |item|
        users[item.id] = {
          id: item.id,
          name: item.full_name,
          avatar_url: item.avatar_url
        }
      end
      dialogs.values.each do |item|
        item[:user] = users[item[:user_id]]
        item.delete(:user_id)
      end
    end

    def set_totals(dialogs)
      messages = Conversation::Message.where(dialog_id: dialogs.keys)
      messages.group(:dialog_id).count.each do |item|
        dialogs[item.first][:total] = item.second
      end
    end

    def set_unreads(dialogs, user_id)
      messages = Conversation::Message.where(
        read: false,
        dialog_id: dialogs.keys,
        recipient_id: user_id
      ).group(:dialog_id).count.each do |item|
        dialogs[item.first][:unread] = item.second
      end
    end

    def set_last_messages(dialogs)
      return if dialogs.empty?
      sql = <<-SQL
        conversation_messages.id in (
          select max(conversation_messages.id) from
          conversation_messages where conversation_messages.dialog_id in (#{dialogs.keys.join(', ')})
          group by conversation_messages.dialog_id
        )
      SQL
      Conversation::Message.where(sql).each do |item|
        last_message = item.as_json(only: [:text, :created_at])
        dialogs[item.dialog_id][:last_message] = last_message
      end
    end
  end
end
