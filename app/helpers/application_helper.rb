module ApplicationHelper
  def active_nav(target)
    if page[:id] == target
      ' class="active"'.html_safe
    else
      ''
    end
  end
end
