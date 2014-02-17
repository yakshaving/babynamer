class BabynameController < ApplicationController

  def show

  end

  def index

  end

  def getnames

    theCategory = params['category']#.capitalize

    @babynames = Babyname.where(category: theCategory).limit(100)

    render json: @babynames

  end


end
