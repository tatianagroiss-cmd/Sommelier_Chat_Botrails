class MoodsController < ApplicationController
  def index
    @moods = Mood.all
  end

  def create
  end
end
