class ApplicationController < ActionController::Base
  User = Struct.new(:id)

  # TODO: auth process
  def current_user
    @current_user ||= User.new(1)
  end
end
