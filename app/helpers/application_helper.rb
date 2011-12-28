module ApplicationHelper

  def title
    base_title = "Bango"
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end

  def logo
    image_tag("logo.png", :alt => "Bango", :class => "round")
  end

end
