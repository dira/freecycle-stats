# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def html_title
    title = APP_CONFIG[:site_name].dup
    title << ": #{@page_title}" if @page_title
    title
  end

  def freecycle_link(what=nil)
    contents =
      case(what || :text)
        when :text
          'Freecycle®'
        when :image
          image_tag('freecycle-logo.jpg')
      end
    link_to contents, 'http://www.freecycle.org/', :target => '_blank', :class => 'minor'
  end
end
