class Admin::AdminController < ApplicationController
  layout "admin"
  before_filter :logged_or_from_localhost

private
  def logged_or_from_localhost
    login_required unless local_request?
  end
end
