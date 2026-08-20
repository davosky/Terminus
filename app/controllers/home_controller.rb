class HomeController < ApplicationController
  skip_after_action :verify_pundit_usage, only: :index

  def index
  end
end
