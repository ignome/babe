module ApplicationHelper

  def render_page_title
    content_tag('title', "#{@page_title} #{Settings.app_name}")
  end

  def render_about_links
    links = Catalog.about
    if not links.nil?
      render_list do |li|
        links.child.limit(4).each do |about|
          li <<  link_to(about.name, about_path(about.slug))
        end
      end
    end
  end

  def notice_message
    flash_messages = []

    flash.each do |type, message|
      type = 'warning' if type == :notice
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
