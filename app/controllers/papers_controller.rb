class PapersController < ApplicationController

  def show
    @paper = Paper.friendly.find params[:id]
  end

end
