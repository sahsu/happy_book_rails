class SayController < ApplicationController
  def hi
  end

  def hi_with_name
    @name = params[:name]
  end

  def hi_names
  end
end
