class ErrorsController < ApplicationController
  def routing
    render file: "#{Rails.root}/public/404.html", status: 404
  end
end
