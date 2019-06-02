# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
html.section(class: 'container has-text-centered', id: 'login-box') do
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
           icon: 'account',
           placeholder: 'Your Username',
           autofocus: true },
         { name: 'login[password]',
           type: 'password',
           icon: 'textbox-password',
           'password-reveal': true,
           placeholder: 'Your Password' }].each do |v|
          div(class: 'control') do
            tag('b-field') do
              tag('b-input', v.merge(size: 'is-medium',
                                     required: true,
                                     'use-html5-validation': false))
            end
          end
        end

        div(class: 'control has-padding-top-lg') do
          div(class: :field) do
            button(class: 'button is-block is-info is-medium is-fullwidth') do
              'Login'
            end
          end
        end
      end
    end
  end

  footer do
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
end
# rubocop:enable Metrics/BlockLength
