[
  { email: 'client1@example.com', first_name: 'Jacob',   last_name: 'Smith', role: 'client' },
  { email: 'client2@example.com', first_name: 'Michael', last_name: 'Johnson', role: 'client' },
  { email: 'lawyer1@example.com', first_name: 'Joshua',  last_name: 'Williams', role: 'lawyer' },
  { email: 'lawyer2@example.com', first_name: 'Matthew', last_name: 'Jones', role: 'lawyer' },
  { email: 'jurist1@example.com', first_name: 'Ethan',   last_name: 'Brown', role: 'jurist' },
  { email: 'jurist2@example.com', first_name: 'Andrew',  last_name: 'Davis', role: 'jurist' }
].each do |user|
  User.create(
    first_name:            user[:first_name],
    last_name:             user[:last_name],
    email:                 user[:email],
    role:                  user[:role],
    password:              '12345678',
    password_confirmation: '12345678',
    confirmed_at:          DateTime.now
  )
end

[
  'ДТП (автогражданская ответственность',
  'Трудовое право',
  'Жилищное право',
  'Земельное право',
  'Наследование',
  'Авторские и смежные права',
  'Предпринимательское право',
  'Семейное право',
  'Уголовное право и процесс',
  'Гражданское право и процесс',
  'Административное право'
].each do |name|
  Category.create(name: name)
end
