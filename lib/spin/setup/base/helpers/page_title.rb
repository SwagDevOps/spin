# frozen_string_literal: true

helpers do
  self.set(:page_title, nil)

  # @param [String] page_title
  def page_title=(page_title)
    settings.page_title = page_title.nil? ? nil : page_title.to_s
  end

  # @return [String|nil]
  def page_title
    settings.page_title
  end
end
