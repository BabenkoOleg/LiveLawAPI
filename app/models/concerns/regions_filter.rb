module RegionsFilter
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(params)
      regions = Region.all

      regions = regions.where('name ~* ?', "^#{params[:query]}") if params[:query]
      return regions.order('size DESC')
    end
  end
end
