module ApplicationHelper

  def render_page_title(title='')
    content_tag('title', title)
  end

  def notice_message
    flash_messages = []

    flash.each do |type, message|
      type = :success if type == :notice
      text = content_tag(:div, link_to("x", "#", :class => "close", 'data-dismiss' => "alert") + message, :class => "alert alert-#{type}")
      flash_messages << text if message
    end

    flash_messages.join("\n").html_safe
  end

  def render_body_tag
    class_attribute = ["#{controller_name}","#{action_name}"].join("-")
    id_attribute = (@body_id)? " id=\"#{@body_id}\"" : "id=\"#{controller_name}\""

    raw(%Q|<!--[if lt IE 7 ]>
      <body #{id_attribute} class="#{class_attribute} ie6"><![endif]-->
      <!--[if gte IE 7 ]>
      <body #{id_attribute} class="#{class_attribute} ie"><![endif]-->
      <!--[if !IE]>-->
      <body #{id_attribute} class="#{class_attribute}">
      <!--<![endif]-->|)
  end
end
