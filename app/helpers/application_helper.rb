# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def html_title
    title = APP_CONFIG[:site_name].dup
    title << ": #{@page_title}" if @page_title
    title
  end
end
