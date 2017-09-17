class UsersMailer < ApplicationMailer
  def send_password(email, password)
    @email = email
    @password = password
    mail(to: email, subject: 'Вы успешно зарегистрированы!')
  end
end
