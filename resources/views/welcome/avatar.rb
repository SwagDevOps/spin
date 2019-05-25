# frozen_string_literal: true

html.div(class: 'is-rounded image is-48x48') do
  tag('progressive-img',
      src: asset_url(image),
      'aspect-ratio': 48.0 / 48)
end
