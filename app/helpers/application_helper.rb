module ApplicationHelper

  def full_title(page_title)
    base_title = "SaintsAlum.com"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

def markdown(text)
  markdown =Redcarpet::Markdown.new(Redcarpet::Render::XHTML,:hard_wrap=>true,:filter_html=>true,:autolink=>true,:no_intra_emphasis=>true)
  markdown.render(text).html_safe
end


end
