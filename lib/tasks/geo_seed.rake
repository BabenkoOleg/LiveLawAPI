namespace :geo do
  task seed: :environment do

    cities = JSON.parse(File.read("#{Rails.root}/db/geo/cities.json"))

    progressbar = ProgressBar.create(
      title: 'Creation of cities:',
      format: "%t %p%% |%b\u{15E7}%i| %a",
      progress_mark: ' ',
      remainder_mark: "\u{FF65}",
      starting_at: 0,
      total: cities.count
    )

    cities.each do |row|
      region = Region.find_or_create_by(name: row['region'])
      city = City.create(name: row['title'], region: region, size: (row['size'] / 1000))
      row['stations'].each { |s| MetroStation.create(name: s, city: city) } if row['stations']
      progressbar.increment
    end
  end
end
