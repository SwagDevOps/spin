# Sample of use

```html 
<section id="alerts-container" class="col-12">
    <div class="alert alert-info" role="alert">
        <p>Lorem Ipsum</p>

        <button type="button" class="close-alert ripple">×</button>
    </div>
    <div class="alert alert-success" role="alert">
        <p>Lorem Ipsum</p>

        <button type="button" class="close-alert ripple">×</button>
    </div>
    <div class="alert alert-warning" role="alert">
        <p>Lorem Ipsum</p>

        <button type="button" class="close-alert ripple">×</button>
    </div>
    <div class="alert alert-danger" role="alert">
        <p>Lorem Ipsum</p>

        <button type="button" class="close-alert ripple">×</button>
    </div>
</section>
```

```ruby
<% unless flash.empty? %>
    <section id="alerts-container" class="col-12">
        <% flash.each do |type, message| %>
            <div class="alert alert-<%= type %>" role="alert">
                <p>
                    <%= h(message) %>
                </p>

                <button type="button" class="close-alert" aria-hidden="true">
                    ×
                </button>
            </div>
        <% end %>
    </section>
<% end %>
```
