module UsersFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(params)
      users = self.where.not(role: 'client')
                  .page(params[:page] || 1).per(params[:per_page] || 20)

      if params[:city]
        users = users.joins(:cities).where(cities: { id: params[:city].split(',') })
      end

      if params[:category]
        users = users.joins(:categories).where(categories: { id: params[:category].split(',') })
      end

      if params[:price]
        range = params[:price].split(',').map(&:to_i)
        users = users.where(price: range.first..range.second)
      end

      if params[:experience]
        range = params[:experience].split(',').map(&:to_i)
        if range.one? && range.first == 1
          users = users.where('experience < 1')
        elsif range.one?
          users = users.where('experience > ?', range.first)
        else
          users = users.where(experience: range[0]..range[1])
        end
      end

      if params[:full_name]
        users = users.where('(first_name||last_name||middle_name) ~* ?', params[:full_name])
      end

      users = users.where(online: params[:online]) if params[:online]

      if params[:chat]
        chat = Chat.find_by(id: params[:chat])
        if chat.present?
          users = users.where.not(id: chat.rejected_ids)
        end
      end

      return users
    end
  end
end
