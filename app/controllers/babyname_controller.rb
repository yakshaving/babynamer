class BabynameController < ApplicationController

  def show

  end

  def index

  end

  def getnames

    @babynames = Babyname.limit(50)


    render json: @babynames

  end


end
