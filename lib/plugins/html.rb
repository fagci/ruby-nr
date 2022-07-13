# frozen_string_literal: true

class Connection
  def get_html_title
    @title = @html.match(/<(title)[^>]*>([^<]+)/i).to_a.last
    self
  end
end
