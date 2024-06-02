class StaticPagesController < ApplicationController
  def home
    @foods = Food.all.limit(4)
  end
end
