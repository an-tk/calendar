module ApplicationHelper
  def nav_link(title, url)
    content_tag(:li, link_to(title, url), :class => (current_page?(url) ? :active : ''))
  end

end
