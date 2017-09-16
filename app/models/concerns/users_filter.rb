module UsersFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(params)
      users = self.page(params[:page] || 1).per(params[:per_page] || 20)

      users = users.where(role: params[:role].split(',')) if params[:role]

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

      return users
    end
  end
end
