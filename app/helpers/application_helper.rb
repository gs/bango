module ApplicationHelper

  def title
    base_title = "Bango"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
end
