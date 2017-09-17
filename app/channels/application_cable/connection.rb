module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # ?access-token=zZ12GuNyGYR5HM7yhYwPpg&client=Fgp76lGbk3xmqCzhBy1DbQ&uid=client1@example.com
    # ?guest-token=ascASFSACajcsSosS5scwP
    def connect
      params = request.query_parameters

      if params['access-token'] && params['client'] && params['uid']
        self.current_user = find_user(params)

      elsif params["guest-token"]
        self.current_user = find_guest(params)

      else
        reject_unauthorized_connection
      end
    end

    private

    def find_user(params)
      access_token = params['access-token']
      client =       params['client']
      uid =          params['uid']

      user = User.find_by(email: uid)
      return user if user && user.valid_token?(access_token, client)

      message = "The user isn't authenticated. Connection rejected"
      self.transmit error: message
      reject_unauthorized_connection
    end

    def find_guest(params)
      guest = Guest.find_by(token: params['guest-token'])
      return guest if guest

      message = "The guest-token isn't found. Connection rejected"
      self.transmit error: message
      reject_unauthorized_connection
    end
  end
end
