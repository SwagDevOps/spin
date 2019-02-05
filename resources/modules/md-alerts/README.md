# Sample of use

```html 
<section id="alerts-container" class="col-12">
    <div class="alert alert-info" role="alert">
        <p class="message">Lorem Ipsum</p>

        <button type="button" class="close">×</button>
    </div>
    <div class="alert alert-success" role="alert">
        <p class="message">Lorem Ipsum</p>

        <button type="button" class="close">×</button>
    </div>
    <div class="alert alert-warning" role="alert">
        <p class="message">Lorem Ipsum</p>

        <button type="button" class="close">×</button>
    </div>
    <div class="alert alert-danger" role="alert">
        <p class="message">Lorem Ipsum</p>

        <button type="button" class="close">×</button>
    </div>
    <div class="alert" role="alert">
        <p class="message">Lorem Ipsum</p>

        <button type="button" class="close">×</button>
    </div>
</section>
```

```ruby
<% unless flash.empty? %>
    <section id="alerts-container" class="col-12">
        <% flash.each do |type, message| %>
            <div class="alert alert-<%= type %> animated slideInRight" role="alert">
                <p class="message">
                    <%= h(message) %>
                </p>

                <button type="button" class="close" aria-hidden="true">
                    ×
                </button>
            </div>
        <% end %>
    </section>
<% end %>
```
