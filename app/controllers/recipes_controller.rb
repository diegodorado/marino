class RecipesController < ApplicationController
  skip_before_filter :authenticate_user!

  respond_to :json

  def index
    @recipes = if params[:keywords]
      Company.where({ :name => /.*#{params[:keywords]}.*/i })
    else
      []
    end
    return render :json => @recipes.to_json
  end
end
