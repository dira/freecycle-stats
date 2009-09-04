# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def html_title
    title = APP_CONFIG[:site_name].dup
    title << ": #{@page_title}" if @page_title
    title
  end

  def freecycle_link(what=nil)
    name = (what == nil || what == :text) ? 'Freecycle®' : image_tag('freecycle-logo.jpg')
    link_to name, 'http://www.freecycle.org/', :target => '_blank', :class => 'minor'
  end
end
