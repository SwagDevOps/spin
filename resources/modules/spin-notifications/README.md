# Sample of use

```html
<section id="notifications">
<div class="notification is-primary animated slideInRight" role="alert">
        <button class="delete" aria-hidden="true"></button>
        <p>
            Primar lorem ipsum dolor sit amet, consectetur
            adipiscing elit lorem ipsum dolor. <strong>Pellentesque risus mi</strong>, tempus quis placerat ut, porta
            nec nulla. Vestibulum rhoncus ac ex sit amet fringilla. Nullam gravida purus diam, et dictum
            <a>felis venenatis</a> efficitur. Sit amet,
            consectetur adipiscing elit
        </p>
    </div>
</section>
```

```ruby
<% unless flash.empty? %>
    <section id="notifications">
        <% flash.each do |type, message| %>
            <div class="notification is-<%= type %> animated slideInRight" role="alert">
                <button class="delete" aria-hidden="true"></button>

                <p>
                    <%= h(message) %>
                </p>
            </div>
        <% end %>
    </section>
<% end %>
```

```js
import notificationClickHandler from 'md-alerts'

notificationClickHandler('#notifications .notification .delete', '#notifications')
```
