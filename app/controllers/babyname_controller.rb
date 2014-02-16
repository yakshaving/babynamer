class BabynameController < ApplicationController

  def show

  end

  def index

  end

  def getnames

    @babynames = Babyname.where(category: params['category']).limit(100)

    render json: @babynames

  end


end
