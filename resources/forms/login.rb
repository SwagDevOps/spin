# frozen_string_literal: true

# @type [Array] self
self.clear.push(lambda do |_f|
  div(class: 'grid') do
    [[:username, :text_field, 'Username'],
     [:password, :password_field, 'Password']].each do |name, type, label|
      div(class: 'col-sm-4 col-bleed-y') do
        div(class: 'mdl-textfield mdl-textfield--floating-label') do
          label(name, class: 'mdl-textfield__label') { label }
          public_send(type, name, class: 'mdl-textfield__input', required: true)
        end
      end
    end
  end
end, lambda do |_f|
  div(class: 'grid') do
    div(class: 'col-sm-12') do
      # rubocop:disable Metrics/LineLength
      submit('Submit', class: 'mdl-button mdl-button--raised mdl-button--colored')
      # rubocop:enable Metrics/LineLength
    end
  end
end)
