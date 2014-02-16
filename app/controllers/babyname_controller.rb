class BabynameController < ApplicationController

  def show
    # return babynames given parameters
    debugger

    @babynames = Babyname.all
    format.json { render json: @babynames}

  end


  def index

  end

end
