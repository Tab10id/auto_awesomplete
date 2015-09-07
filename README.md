# AutoAwesomplete

Gem provide API (scripts, helpers, controller and base class for ajax-search)
for initialize ajax awesomplete elements.

The `AutoAwesomplete` based on [awesomplete](https://github.com/fishbullet/awesomplete) gem.

[![Gem Version](https://badge.fury.io/rb/auto_awesomplete.png)](http://badge.fury.io/rb/auto_awesomplete)

## Installation

### First

Install [awesomplete](https://github.com/fishbullet/awesomplete#getting-started)
and include javascript and stylesheet assets.

### Second

Add this line to your application's Gemfile:

    gem 'auto_awesomplete'

And then execute:

    $ bundle

### Third

Select one of ways to include js in pipeline. Ways described below in section `Javascript include variants`

### Fourth

Check controller and route collation. Gem contain controller `AutoAwesompletesController` and route

    get 'auto_awesompletes/:class_name'

### Fifth

Prepare folder `app/awesomplete_search_adapters`. This folder needed for storage custom `SearchAdapter`.

## Compatibility

Gem tested and works in Rails 3.2 (with manual install awesomplete assets) and Rails 4.0.
You can test compatibility with other versions by yourself.

## Easiest way to use

Use [AutoAwesomplete2Tag](https://github.com/Tab10id/auto_awesomplete_tag). It provide helper:

* awesomplete_ajax_tag

and you can define ajax awesomplete element like any other view elements in rails.

## Example

(stub)

## Usage

### Javascript include variants

You have two ways to include javascript files. First: in gem presents helper method

* ajax_awesomplete_init_script

These helpers call `javascript_include_tag` and it is useful for initialize awesomplete
scripts on a single page. Example of usage in a view:

    - ajax_awesomplete_init_script
    
    = ajax_awesomplete_tag :my_select, my_options_for_awesomplete, class: 'small'

Second variant: include files in javascript assets. For this add the
following to your `app/assets/javascripts/application.js`:

    //= require auto_awesomplete/ajax

### Ajax awesomplete usage

For initialize ajax awesomplete you must set `auto-ajax-awesomplete` css-class for input element.
Then you have two ways. Easy way for simple selection: specify `default_class_name`, `default_text_column` and
`default_id_column` as params for `:data-awesomplete-href`
Other way for custom selection: create `SearchAdapter`. This adapter has following requirements:

* class must be inherited from `AutoAwesomplete::SearchAdapter::Base`
* file must be put in autoload folder (`app/awesomplete_search_adapter` for example)
* name of a adapter class must end with `SearchAdapter`
* must has function `search_default(term, page, options)`
  (description of the function and return value goes below)

Returned value of `search_default` function must return Array as json

**TIP:** in `search_default` you can use functions from `AutoAwesomplete::SearchAdapter::Base`

Finally input must has `:data-awesomplete-href` attribute. This
parameter specify url for ajax load select options. You can use helper

    auto_awesompletes_path(class_name: :my_class_name)
or

    auto_awesompletes_path(default_class_name: my_class,
                               default_text_column: :name,
                               default_id_column: :id)

### Example of minimalistic SearchAdapter
    class SystemRoleSearchAdapter < AutoAwesomplete::SearchAdapter::Base
      class << self
        def search_default(term, page, options)
          roles = default_finder(SystemRole, term, page: page).pluck(:name)
        end
      end
    end

### More about SearchAdapter

`SearchAdapter` has some additional functions. First, you can define multiple search
functions in one adapter. For example in adapter for User you want to find among all
users, find users only in one department and so on. For this purpose define methods like

    def search_unusual_case(term, page, options)
      # must has same behavior as search_default
    end

near the `search_default` in `SearchAdapter`. Requirement for non-default search methods:

* it must has same behavior as search_default
* name of methods must start with `search_`

For use custom searcher specify it into `:data-awesomplete-href` attribute:

    auto_awesompletes_path(class_name: MyClassName, search_method: :unusual_case)

## Contributing

1. Fork it ( http://github.com/Tab10id/auto_awesomplete/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
