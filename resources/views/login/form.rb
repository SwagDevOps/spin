# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
html.section(class: 'container has-text-centered', id: 'login') do
  div(class: 'column is-4 is-offset-4') do
    h3(class: 'title has-text-grey') { 'Login' }
    p(class: 'subtitle has-text-grey') { 'Please login to proceed.' }

    div(class: 'box') do
      figure(class: 'avatar') do
        img('aria-hidden': true,
            alt: 'avatar',
            src: asset_url('/images/icons/avatar_square_grey_512dp.png'))
      end

      form(action: '/login', method: 'POST') do
        div { raw(csrf_tag) }

        [{ name: 'login[username]',
           type: 'text',
           placeholder: 'Your Username',
           autofocus: true },
         { name: 'login[password]',
           type: 'password',
           placeholder: 'Your Password' }].each do |v|
          div(class: 'field') do
            p(class: 'control') do
              input(v.merge(class: 'input is-large', required: true))
            end
          end
        end

        button(class: 'button is-block is-info is-large is-fullwidth') do
          'Login'
        end
      end
    end
  end

  ul do
    [['Sign Up', '#'],
     ['Forgot Password', '#'],
     ['Need Help?', '#']].each do |label, url|
      li do
        a(ref: url) { label.to_s }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
