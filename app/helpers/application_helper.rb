module ApplicationHelper
  def estimate_for(story)
    story.estimate == '-1' || story.estimate.blank? ? '-' : story.estimate
  end

  def flash_messages
    flash.inject("") do |message, (type, msg)|
      message << content_tag(:div, msg, :class => type)
    end.html_safe
  end
end
