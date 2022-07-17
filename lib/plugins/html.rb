# frozen_string_literal: true

class Connection
  def get_html_title
    matches = @html.match(/<title[^>]*>([^<]+)/i)
    @title = matches.to_a.last.to_s.strip
    false if @title.empty?
  end
end
