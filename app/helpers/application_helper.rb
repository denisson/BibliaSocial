module ApplicationHelper
  def breadcrumb(array)
    content_tag :p, :id => 'breadcrumb' do
      array.map { |pair| link_to(pair[0], pair[1]) }.join(' > ').html_safe
    end
  end
  
  def title(title)
    content_for(:title) { title }
  end
  
  def description(description)
    content_for(:description) { description }
  end
  
  def highlight(text)
    result = String.new(text)
    if params[:keywords] =~ /"(.+)"/
      result.gsub!(/\b(#{$1})\b/i, '<span class="highlight">\1</span>')
    else
      params[:keywords].split(/[\s+-]+/).each do |keyword|
        result.gsub!(/\b(#{keyword})\b/i, '<span class="highlight">\1</span>') unless keyword.blank?
      end
    end unless params[:keywords].blank?
    result.html_safe
  end

  def link_to_versiculo(versiculo)
    link_to versiculo.ref, versiculo.url, {:title=>versiculo.texto, :"data-versiculo-id" => versiculo.id, :class => "linkVersiculo"}
  end

  def bibliasocial_error_messages(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { | msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_updated",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
