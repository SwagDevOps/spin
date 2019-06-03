# frozen_string_literal: true

size = image_size(image)
html.div(class: 'card-image', 'data-updated_at': Time.now) do
  tag('progressive-img',
      src: asset_url(image),
      ':aspect-ratio': (size.height * 1.0) / size.width)
end
