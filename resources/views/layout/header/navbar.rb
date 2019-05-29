# frozen_string_literal: true

html.div(class: 'navbar-item is-flex-touch') do
  a(class: 'navbar-item') do
    span('class': 'icon mdi mdi-compass mdi-24px')
  end

  a(class: 'navbar-item') do
    span('class': 'icon mdi mdi-heart-outline mdi-24px')
  end

  if current_user
    a(class: 'navbar-item', href: '/logout') do
      span('class': 'icon mdi mdi-logout-variant mdi-24px')
    end
  end

  unless current_user
    a(class: 'navbar-item', href: '/login') do
      span('class': 'icon mdi mdi-account-outline mdi-24px')
    end
  end
end
