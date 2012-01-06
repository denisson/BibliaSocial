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
end
