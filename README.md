# Infienity

Infienity provides infinity scroll, combined with sort and search via web-socket connection. Since infinity scroll requires continuous calls to request new parts of the data, requesting new data via a permanent web-socket connection should be a cleaner approach than using traditional AJAX calls.

This gem is dependent on [Fie]("https://github.com/raen79/fie"), a gem that makes DOM manipulations through web sockets possible. It works by... (TODO).

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'infienity'
gem 'fie' # dependency, use your preferred version
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install infienity

Add Infienity's javascript in your project, by adding the following lines into `app/assets/javascripts/application.js`:

```ruby
# just before require_tree
//= require fie
//= require infienity
```

As Infienity is dependent on Fie, you will have to follow the regular [Fie setup]("https://github.com/raen79/fie"), which also includes setting up Redis.

## Usage
For both infinity scroll, searching and sorting you will need to perform the following steps:

Add the following line in the model you want to perform the actions on:
```ruby
extend Infienity::Model
```

Create a commander for your model (for front-end manipulation). The commander should be correspondant to the controller of your model (path: `app/commanders/[name]_commander).
```ruby
class HomeCommander < Fie::Commander
  extend Infienity::Commander
  commander_assigns :users # model name in this format
end
```

In your controller method, you will need to assign some variables, which will hold the state. you must declare all of them in order for the infinity scroll to work:
```ruby
@index = 0
@per_page = 10 # choose your preferred amount
```

### Pagination

In your controller method, perform the pagination of the infinity scroll like so:
```ruby
@users = User.paginate
```

In your view, for each data entry, wrap it up in a span, with the following class and custom attribute. `infienity-model` should include your model name, in plural.
Example:
```ruby
<% @users.each do |u| %>
    <span class="paginate" infienity-model="users">
        Name: <%= u.full_name %> <br/>
        Username: <%= u.username %>
    </span>
<% end %>
```

### Search

In your controller method, add the following variables, in order to hold the state:
```ruby
@search_attribute = 'username'
@search_string = ''
```

In your view, you can use this predefined layout:
```ruby
<%= render template: 'layouts/search', locals: { assign: "users", search_string: @search_string } %>
```

Or use html in this manner:
```html
<input type="text" name="search_string" value="<%= @search_string %>" fie-keyup="filter_users" > </input>
```
Note: be careful to put the correct assign for `fie-keyup` attribute

### Sort

In your controller method, add the following variables, in order to hold the state:
```ruby
@sorting_dropdown_options =
    {
    "Username (A-Z)" => [:username, :asc],
    "Username (Z-A)" => [:username, :desc],
    "Date (Asc)" => [:created_at, :asc],
    "Date (Desc)" => [:created_at, :desc]
    }
@selected_dropdown_option = "Username (A-Z)"
```
- The keys in the `@sorting_dropdown_options` are the values the user is going to see.
- The first value in `@sorting_dropdown_options` is the model attruibute, and the second is always `:asc` or `:desc`.
- The `@selected_dropdown_option` must correspond to one of the keys stated in `@sorting_dropdown_options`

If you use a custom dropdown using `<li>` elements, you can use this template:
```ruby
<%= render
  template: 'layouts/sort',
  locals:
    {
      dropdown_options: @sorting_dropdown_options,
      current_option: @selected_dropdown_option,
      assign: "users"
    }
%>
```

Or for a basic `<select>` dropdown:
```ruby
<%= render
  template: 'layouts/sort_select',
  locals: {
    dropdown_options: @sorting_dropdown_options,
    current_option: @selected_dropdown_option,
    assign: "users"
  }
%>
```

Or use html in this manner:
```html
<div class="dropdown">
    <button type="button" data-toggle="dropdown"> <%= @selected_dropdown_option %>
      <span class="caret"></span>
    </button>
    <ul class="dropdown-menu">
        <% @selected_dropdown_option.each do |key,val| %>
            <li fie-click="sort_users" fie-parameters= "<%= { sort: {key => val} }.to_json %>"> <%= key %> </li>
        <% end %>
    </ul>
</div>
```
Note: be careful to put the correct assign for `fie-click` attribute

### Template options

To style the html in the templates, add the `options` hash inside the locals hash, in this manner:
```ruby
<%= render
  template: 'layouts/sort',
  locals:
    {
      dropdown_options: @sorting_dropdown_options,
      current_option: @selected_dropdown_option,
      assign: "users",
      options: { class: "btn btn-primary dropdown-toggle" }
    }
%>
```

Supported options:
- `:id`
- `:class`
- `:name`

## Development

Your first step is to run `npm install` within the root folder in order to install the relevant NodeJS packages.

To work on the JavaScript, begin by running `npm run build`. This will start a watcher that will automatically transpile your ES6 within the `ib/javascripts` folder into a bundle within `vendor/javascripts/infienity.js` using webpacker.

The Ruby files can be found within `lib/infienity` and their development is the same as in any other gem.

Please add tests if you add new features or resolve bugs.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ioanabob/infienity. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Infienity project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/infienity/blob/master/CODE_OF_CONDUCT.md).
