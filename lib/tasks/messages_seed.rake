namespace :messages do
  task seed: :environment do

    user_ids = User.all.ids.sort.to_a

    combinations = []

    user_ids.each do |user_id|
      recipients = user_ids.reject { |i| i == user_id }
      recipients.each { |recipient_id| combinations << [user_id, recipient_id].sort }
    end
    combinations.uniq!

    puts '-- combinations are collected!'

    dialogs = []
    time = DateTime.now
    combinations.each do |combination|
      dialogs << { user_1_id: combination[0], user_2_id: combination[1] }
    end
    dialog_ids = Conversation::Dialog.import(dialogs, validate: false).ids
    dialog_ids.each_with_index { |id, i| combinations[i] << id }

    puts '-- dialogs are created!'

    progressbar = ProgressBar.create(
      title: 'Creation of messages:',
      format: "%t %p%% |%b\u{15E7}%i| %a",
      progress_mark: ' ',
      remainder_mark: "\u{FF65}",
      starting_at: 0,
      total: combinations.count / 1000
    )

    combinations.each_slice(1000) do |batch|
      messages = []

      batch.each do |combination|
        rand(1..3).times do
          text = Faker::Lorem.sentence
          time = DateTime.now
          messages << { sender_id: combination[0], recipient_id: combination[1], text: text, dialog_id: combination[2], created_at: time, updated_at: time }

          text = Faker::Lorem.sentence
          time = DateTime.now
          messages << { sender_id: combination[1], recipient_id: combination[0], text: text, dialog_id: combination[2], created_at: time, updated_at: time }
        end
      end

      Conversation::Message.import(messages, validate: false)
      progressbar.increment
    end
  end
end
