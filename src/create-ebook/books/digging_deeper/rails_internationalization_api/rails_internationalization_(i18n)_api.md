---
title: Rails Internationalization (I18n) API
author: Ruby on Rails
rights: Creative Commons Attribution-ShareAlike 4.0 International
language: en-US
...

# Rails Internationalization (I18n) API

The Ruby I18n (shorthand for internationalization) gem which is shipped with Ruby on Rails (starting from Rails 2.2) provides an easy-to-use and extensible framework for translating your application to a single custom language other than English or for providing multi-language support in your application.
The process of "internationalization" usually means to abstract all strings and other locale specific bits (such as date or currency formats) out of your application. The process of "localization" means to provide translations and localized formats for these bits.1

+ Ensure you have support for i18n.
+ Tell Rails where to find locale dictionaries.
+ Tell Rails how to set, preserve and switch locales.


**Note:** The Ruby I18n framework provides you with all necessary means for internationalization/localization of your Rails application. You may, also use various gems available to add additional functionality or features. See the [rails-i18n gem](https://github.com/svenfuchs/rails-i18n) for more information.

# 1 How I18n in Ruby on Rails Works

Internationalization is a complex problem. Natural languages differ in so many ways (e.g. in pluralization rules) that it is hard to provide tools for solving all problems at once. For that reason the Rails I18n API focuses on:

+ providing support for English and similar languages out of the box
+ making it easy to customize and extend everything for other languages

As part of this solution,  - e.g. Active Record validation messages, time and date formats - , so  of a Rails application means "over-riding" these defaults.

##  1.1 The Overall Architecture of the Library

Thus, the Ruby I18n gem is split into two parts:

+ The public API of the i18n framework - a Ruby module with public methods that define how the library works
+ A default backend (which is intentionally named  backend) that implements these methods

As a user you should always only access the public methods on the I18n module, but it is useful to know about the capabilities of the backend.

**Note:** It is possible (or even desirable) to swap the shipped Simple backend with a more powerful one, which would store translation data in a relational database, GetText dictionary, or similar. See section [Using different backends](#using-different-backends) below.

##  1.2 The Public I18n API

The most important methods of the I18n API are:

```ruby
translate # Lookup text translations
localize  # Localize Date and Time objects to local formats
```

These have the aliases #t and #l so you can use them like this:

```ruby
I18n.t 'store.title'
I18n.l Time.now
```

There are also attribute readers and writers for the following attributes:

```ruby
load_path         # Announce your custom translation files
locale            # Get and set the current locale
default_locale    # Get and set the default locale
exception_handler # Use a different exception_handler
backend           # Use a different backend
```

So, let's internationalize a simple Rails application from the ground up in the next chapters!

# 2 Setup the Rails Application for Internationalization

There are just a few simple steps to get up and running with I18n support for your application.

##  2.1 Configure the I18n Module

Following the  philosophy, Rails will set up your application with reasonable defaults. If you need different settings, you can overwrite them easily.

Rails adds all `.rb` and `.yml` files from the `config/locales` directory to your , automatically.

The default `en.yml` locale in this directory contains a sample pair of translation strings:

```ruby
en:
  hello: "Hello world"
```

This means, that in the `:en` locale, the key  will map to the  string. Every string inside Rails is internationalized in this way, see for instance Active Model validation messages in the [activemodel/lib/active_model/locale/en.yml](https://github.com/rails/rails/blob/master/activemodel/lib/active_model/locale/en.yml) file or time and date formats in the [activesupport/lib/active_support/locale/en.yml](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/locale/en.yml) file. You can use YAML or standard Ruby Hashes to store translations in the default (Simple) backend.

The I18n library will use  as a , i.e. if you don't set a different locale, `:en` will be used for looking up translations.

**Note:** The i18n library takes a  to locale keys (after [some discussion](http://groups.google.com/group/rails-i18n/browse_thread/thread/14dede2c7dbe9470/80eec34395f64f3c?hl=en)), including only the  ("language") part, like `:en`, `:pl`, not the  part, like `:en-US` or `:en-GB`, which are traditionally used for separating "languages" and "regional setting" or "dialects". Many international applications use only the "language" element of a locale such as `:cs`, `:th` or `:es` (for Czech, Thai and Spanish). However, there are also regional differences within different language groups that may be important. For instance, in the `:en-US` locale you would have $ as a currency symbol, while in `:en-GB`, you would have £. Nothing stops you from separating regional and other settings in this way: you just have to provide full "English - United Kingdom" locale in a `:en-GB` dictionary. Few gems such as [Globalize3](https://github.com/globalize/globalize) may help you implement it.

The  (`I18n.load_path`) is just a Ruby Array of paths to your translation files that will be loaded automatically and available in your application. You can pick whatever directory and translation file naming scheme makes sense for you.

**Note:** The backend will lazy-load these translations when a translation is looked up for the first time. This makes it possible to just swap the backend with something else even after translations have already been announced.

The default `application.rb` file has instructions on how to add locales from another directory and how to set a different default locale. Just uncomment and edit the specific lines.

```ruby
# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
# config.i18n.default_locale = :de
```

##  2.2 Optional: Custom I18n Configuration Setup

For the sake of completeness, let's mention that if you do not want to use the `application.rb` file for some reason, you can always wire up things manually, too.

To tell the I18n library where it can find your custom translation files you can specify the load path anywhere in your application - just make sure it gets run before any translations are actually looked up. You might also want to change the default locale. The simplest thing possible is to put the following into an initializer:

```ruby
# in config/initializers/locale.rb

# tell the I18n library where to find your translations
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# set default locale to something other than :en
I18n.default_locale = :pt
```

##  2.3 Setting and Passing the Locale

If you want to translate your Rails application to a  (the default locale), you can set I18n.default_locale to your locale in `application.rb` or an initializer as shown above, and it will persist through the requests.

However, you would probably like to  in your application. In such case, you need to set and pass the locale between requests.

**Warning:** You may be tempted to store the chosen locale in a  or a . However, . The locale should be transparent and a part of the URL. This way you won't break people's basic assumptions about the web itself: if you send a URL to a friend, they should see the same page and content as you. A fancy word for this would be that you're being [RESTful](http://en.wikipedia.org/wiki/Representational_State_Transfer). Read more about the RESTful approach in [Stefan Tilkov's articles](http://www.infoq.com/articles/rest-introduction). Sometimes there are exceptions to this rule and those are discussed below.

The  is easy. You can set the locale in a `before_action` in the `ApplicationController` like this:

```ruby
before_action :set_locale

def set_locale
  I18n.locale = params[:locale] || I18n.default_locale
end
```

This requires you to pass the locale as a URL query parameter as in `http://example.com/books?locale=pt`. (This is, for example, Google's approach.) So `http://localhost:3000?locale=pt` will load the Portuguese localization, whereas `http://localhost:3000?locale=de` would load the German localization, and so on. You may skip the next section and head over to the  section, if you want to try things out by manually placing the locale in the URL and reloading the page.

Of course, you probably don't want to manually include the locale in every URL all over your application, or want the URLs look differently, e.g. the usual `http://example.com/pt/books` versus `http://example.com/en/books`. Let's discuss the different options you have.

##  2.4 Setting the Locale from the Domain Name

One option you have is to set the locale from the domain name where your application runs. For example, we want `www.example.com` to load the English (or default) locale, and `www.example.es` to load the Spanish locale. Thus the  is used for locale setting. This has several advantages:

+ The locale is an  part of the URL.
+ People intuitively grasp in which language the content will be displayed.
+ It is very trivial to implement in Rails.
+ Search engines seem to like that content in different languages lives at different, inter-linked domains.

You can implement it like this in your `ApplicationController`:

```ruby
before_action :set_locale

def set_locale
  I18n.locale = extract_locale_from_tld || I18n.default_locale
end

# Get locale from top-level domain or return nil if such locale is not available
# You have to put something like:
#   127.0.0.1 application.com
#   127.0.0.1 application.it
#   127.0.0.1 application.pl
# in your /etc/hosts file to try this out locally
def extract_locale_from_tld
  parsed_locale = request.host.split('.').last
  I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
end
```

We can also set the locale from the  in a very similar way:

```ruby
# Get locale code from request subdomain (like http://it.application.local:3000)
# You have to put something like:
#   127.0.0.1 gr.application.local
# in your /etc/hosts file to try this out locally
def extract_locale_from_subdomain
  parsed_locale = request.subdomains.first
  I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
end
```

If your application includes a locale switching menu, you would then have something like this in it:

```ruby
link_to("Deutsch", "#{APP_CONFIG[:deutsch_website_url]}#{request.env['REQUEST_URI']}")
```

assuming you would set `APP_CONFIG[:deutsch_website_url]` to some value like `http://www.application.de`.

This solution has aforementioned advantages, however, you may not be able or may not want to provide different localizations ("language versions") on different domains. The most obvious solution would be to include locale code in the URL params (or request path).

##  2.5 Setting the Locale from the URL Params

The most usual way of setting (and passing) the locale would be to include it in URL params, as we did in the `I18n.locale = params[:locale]`  in the first example. We would like to have URLs like `www.example.com/books?locale=ja` or `www.example.com/ja/books` in this case.

This approach has almost the same set of advantages as setting the locale from the domain name: namely that it's RESTful and in accord with the rest of the World Wide Web. It does require a little bit more work to implement, though.

Getting the locale from `params` and setting it accordingly is not hard; including it in every URL and thus  is. To include an explicit option in every URL, e.g. `link_to(books_url(locale: I18n.locale))`, would be tedious and probably impossible, of course.

Rails contains infrastructure for "centralizing dynamic decisions about the URLs" in its [ApplicationController#default_url_options](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Base.html#method-i-default_url_options), which is useful precisely in this scenario: it enables us to set "defaults" for [url_for](http://api.rubyonrails.org/classes/ActionDispatch/Routing/UrlFor.html#method-i-url_for) and helper methods dependent on it (by implementing/overriding this method).

We can include something like this in our `ApplicationController` then:

```ruby
# app/controllers/application_controller.rb
def default_url_options(options = {})
  { locale: I18n.locale }.merge options
end
```

Every helper method dependent on `url_for` (e.g. helpers for named routes like `root_path` or `root_url`, resource routes like `books_path` or `books_url`, etc.) will now , like this: `http://localhost:3001/?locale=ja`.

You may be satisfied with this. It does impact the readability of URLs, though, when the locale "hangs" at the end of every URL in your application. Moreover, from the architectural standpoint, locale is usually hierarchically above the other parts of the application domain: and URLs should reflect this.

You probably want URLs to look like this: `www.example.com/en/books` (which loads the English locale) and `www.example.com/nl/books` (which loads the Dutch locale). This is achievable with the "over-riding `default_url_options`" strategy from above: you just have to set up your routes with [scoping](http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Scoping.html) option in this way:

```ruby
# config/routes.rb
scope "/:locale" do
  resources :books
end
```

Now, when you call the `books_path` method you should get `"/en/books"` (for the default locale). An URL like `http://localhost:3001/nl/books` should load the Dutch locale, then, and following calls to `books_path` should return `"/nl/books"` (because the locale changed).

If you don't want to force the use of a locale in your routes you can use an optional path scope (denoted by the parentheses) like so:

```ruby
# config/routes.rb
scope "(:locale)", locale: /en|nl/ do
  resources :books
end
```

With this approach you will not get a `Routing Error` when accessing your resources such as `http://localhost:3001/books` without a locale. This is useful for when you want to use the default locale when one is not specified.

Of course, you need to take special care of the root URL (usually "homepage" or "dashboard") of your application. An URL like `http://localhost:3001/nl` will not work automatically, because the `root to: "books#index"` declaration in your `routes.rb` doesn't take locale into account. (And rightly so: there's only one "root" URL.)

You would probably need to map URLs like these:

```ruby
# config/routes.rb
get '/:locale' => 'dashboard#index'
```

Do take special care about the , so this route declaration does not "eat" other ones. (You may want to add it directly before the `root :to` declaration.)

**Note:** Have a look at various gems which simplify working with routes: [routing_filter](https://github.com/svenfuchs/routing-filter/tree/master), [rails-translate-routes](https://github.com/francesc/rails-translate-routes), [route_translator](https://github.com/enriclluelles/route_translator).

##  2.6 Setting the Locale from the Client Supplied Information

In specific cases, it would make sense to set the locale from client-supplied information, i.e. not from the URL. This information may come for example from the users' preferred language (set in their browser), can be based on the users' geographical location inferred from their IP, or users can provide it simply by choosing the locale in your application interface and saving it to their profile. This approach is more suitable for web-based applications or services, not for websites - see the box about ,  and RESTful architecture above.

###  2.6.1 Using `Accept-Language`

One source of client supplied information would be an `Accept-Language` HTTP header. People may [set this in their browser](http://www.w3.org/International/questions/qa-lang-priorities) or other clients (such as ).

A trivial implementation of using an `Accept-Language` header would be:

```ruby
def set_locale
  logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
  I18n.locale = extract_locale_from_accept_language_header
  logger.debug "* Locale set to '#{I18n.locale}'"
end

private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
```

Of course, in a production environment you would need much more robust code, and could use a gem such as Iain Hecker's [http_accept_language](https://github.com/iain/http_accept_language/tree/master) or even Rack middleware such as Ryan Tomayko's [locale](https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/locale.rb).

###  2.6.2 Using GeoIP (or Similar) Database

Another way of choosing the locale from client information would be to use a database for mapping the client IP to the region, such as [GeoIP Lite Country](http://www.maxmind.com/app/geolitecountry). The mechanics of the code would be very similar to the code above - you would need to query the database for the user's IP, and look up your preferred locale for the country/region/city returned.

###  2.6.3 User Profile

You can also provide users of your application with means to set (and possibly over-ride) the locale in your application interface, as well. Again, mechanics for this approach would be very similar to the code above - you'd probably let users choose a locale from a dropdown list and save it to their profile in the database. Then you'd set the locale to this value.

# 3 Internationalizing your Application

OK! Now you've initialized I18n support for your Ruby on Rails application and told it which locale to use and how to preserve it between requests. With that in place, you're now ready for the really interesting stuff.

Let's  our application, i.e. abstract every locale-specific parts, and then  it, i.e. provide necessary translations for these abstracts.

You most probably have something like this in one of your applications:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root to: "home#index"
end
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
```

```ruby
# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    flash[:notice] = "Hello Flash"
  end
end
```

```ruby
# app/views/home/index.html.erb
<h1>Hello World</h1>
<p><%= flash[:notice] %></p>
```

![](images/i18n/demo_untranslated.png)

##  3.1 Adding Translations

Obviously there are . In order to internationalize this code,  with calls to Rails' `#t` helper with a key that makes sense for the translation:

```ruby
# app/controllers/home_controller.rb
class HomeController < ApplicationController
  def index
    flash[:notice] = t(:hello_flash)
  end
end
```

```ruby
# app/views/home/index.html.erb
<h1><%=t :hello_world %></h1>
<p><%= flash[:notice] %></p>
```

When you now render this view, it will show an error message which tells you that the translations for the keys `:hello_world` and `:hello_flash` are missing.

![](images/i18n/demo_translation_missing.png)

**Note:** Rails adds a `t` (`translate`) helper method to your views so that you do not need to spell out `I18n.t` all the time. Additionally this helper will catch missing translations and wrap the resulting error message into a `<span class="translation_missing">`.

So let's add the missing translations into the dictionary files (i.e. do the "localization" part):

```ruby
# config/locales/en.yml
en:
  hello_world: Hello world!
  hello_flash: Hello flash!

# config/locales/pirate.yml
pirate:
  hello_world: Ahoy World
  hello_flash: Ahoy Flash
```

There you go. Because you haven't changed the default_locale, I18n will use English. Your application now shows:

![](images/i18n/demo_translated_en.png)

And when you change the URL to pass the pirate locale (`http://localhost:3000?locale=pirate`), you'll get:

![](images/i18n/demo_translated_pirate.png)

**Note:** You need to restart the server when you add new locale files.

You may use YAML (`.yml`) or plain Ruby (`.rb`) files for storing your translations in SimpleStore. YAML is the preferred option among Rails developers. However, it has one big disadvantage. YAML is very sensitive to whitespace and special characters, so the application may not load your dictionary properly. Ruby files will crash your application on first request, so you may easily find what's wrong. (If you encounter any "weird issues" with YAML dictionaries, try putting the relevant portion of your dictionary into a Ruby file.)

##  3.2 Passing variables to translations

You can use variables in the translation messages and pass their values from the view.

```ruby
# app/views/home/index.html.erb
<%=t 'greet_username', user: "Bill", message: "Goodbye" %>
```

```ruby
# config/locales/en.yml
en:
  greet_username: "%{message}, %{user}!"
```

##  3.3 Adding Date/Time Formats

OK! Now let's add a timestamp to the view, so we can demo the  feature as well. To localize the time format you pass the Time object to `I18n.l` or (preferably) use Rails' `#l` helper. You can pick a format by passing the `:format` option - by default the `:default` format is used.

```ruby
# app/views/home/index.html.erb
<h1><%=t :hello_world %></h1>
<p><%= flash[:notice] %></p
<p><%= l Time.now, format: :short %></p>
```

And in our pirate translations file let's add a time format (it's already there in Rails' defaults for English):

```ruby
# config/locales/pirate.yml
pirate:
  time:
    formats:
      short: "arrrround %H'ish"
```

So that would give you:

![](images/i18n/demo_localized_pirate.png)

**Info:** Right now you might need to add some more date/time formats in order to make the I18n backend work as expected (at least for the 'pirate' locale). Of course, there's a great chance that somebody already did all the work by . See the [rails-i18n repository at GitHub](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale) for an archive of various locale files. When you put such file(s) in `config/locales/` directory, they will automatically be ready for use.

##  3.4 Inflection Rules For Other Locales

Rails allows you to define inflection rules (such as rules for singularization and pluralization) for locales other than English. In `config/initializers/inflections.rb`, you can define these rules for multiple locales. The initializer contains a default example for specifying additional rules for English; follow that format for other locales as you see fit.

##  3.5 Localized Views

Let's say you have a  in your application. Your  action renders content in `app/views/books/index.html.erb` template. When you put a  of this template: `index.es.html.erb` in the same directory, Rails will render content in this template, when the locale is set to `:es`. When the locale is set to the default locale, the generic `index.html.erb` view will be used. (Future Rails versions may well bring this  localization to assets in `public`, etc.)

You can make use of this feature, e.g. when working with a large amount of static content, which would be clumsy to put inside YAML or Ruby dictionaries. Bear in mind, though, that any change you would like to do later to the template must be propagated to all of them.

##  3.6 Organization of Locale Files

When you are using the default SimpleStore shipped with the i18n library, dictionaries are stored in plain-text files on the disc. Putting translations for all parts of your application in one file per locale could be hard to manage. You can store these files in a hierarchy which makes sense to you.

For example, your `config/locales` directory could look like this:

```ruby
|-defaults
|---es.rb
|---en.rb
|-models
|---book
|-----es.rb
|-----en.rb
|-views
|---defaults
|-----es.rb
|-----en.rb
|---books
|-----es.rb
|-----en.rb
|---users
|-----es.rb
|-----en.rb
|---navigation
|-----es.rb
|-----en.rb
```

This way, you can separate model and model attribute names from text inside views, and all of this from the "defaults" (e.g. date and time formats). Other stores for the i18n library could provide different means of such separation.

**Note:** The default locale loading mechanism in Rails does not load locale files in nested dictionaries, like we have here. So, for this to work, we must explicitly tell Rails to look further:

```ruby
# config/application.rb
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
```

# 4 Overview of the I18n API Features

You should have good understanding of using the i18n library now, knowing all necessary aspects of internationalizing a basic Rails application. In the following chapters, we'll cover it's features in more depth.

These chapters will show examples using both the `I18n.translate` method as well as the [translate view helper method](http://api.rubyonrails.org/classes/ActionView/Helpers/TranslationHelper.html#method-i-translate) (noting the additional feature provide by the view helper method).

Covered are features like these:

+ looking up translations
+ interpolating data into translations
+ pluralizing translations
+ using safe HTML translations (view helper method only)
+ localizing dates, numbers, currency, etc.

##  4.1 Looking up Translations

###  4.1.1 Basic Lookup, Scopes and Nested Keys

Translations are looked up by keys which can be both Symbols or Strings, so these calls are equivalent:

```ruby
I18n.t :message
I18n.t 'message'
```

The `translate` method also takes a `:scope` option which can contain one or more additional keys that will be used to specify a "namespace" or scope for a translation key:

```ruby
I18n.t :record_invalid, scope: [:activerecord, :errors, :messages]
```

This looks up the `:record_invalid` message in the Active Record error messages.

Additionally, both the key and scopes can be specified as dot-separated keys as in:

```ruby
I18n.translate "activerecord.errors.messages.record_invalid"
```

Thus the following calls are equivalent:

```ruby
I18n.t 'activerecord.errors.messages.record_invalid'
I18n.t 'errors.messages.record_invalid', scope: :active_record
I18n.t :record_invalid, scope: 'activerecord.errors.messages'
I18n.t :record_invalid, scope: [:activerecord, :errors, :messages]
```

###  4.1.2 Defaults

When a `:default` option is given, its value will be returned if the translation is missing:

```ruby
I18n.t :missing, default: 'Not here'
# => 'Not here'
```

If the `:default` value is a Symbol, it will be used as a key and translated. One can provide multiple values as default. The first one that results in a value will be returned.

E.g., the following first tries to translate the key `:missing` and then the key `:also_missing.` As both do not yield a result, the string "Not here" will be returned:

```ruby
I18n.t :missing, default: [:also_missing, 'Not here']
# => 'Not here'
```

###  4.1.3 Bulk and Namespace Lookup

To look up multiple translations at once, an array of keys can be passed:

```ruby
I18n.t [:odd, :even], scope: 'errors.messages'
# => ["must be odd", "must be even"]
```

Also, a key can translate to a (potentially nested) hash of grouped translations. E.g., one can receive  Active Record error messages as a Hash with:

```ruby
I18n.t 'activerecord.errors.messages'
# => {:inclusion=>"is not included in the list", :exclusion=> ... }
```

###  4.1.4 "Lazy" Lookup

Rails implements a convenient way to look up the locale inside . When you have the following dictionary:

```ruby
es:
  books:
    index:
      title: "Título"
```

you can look up the `books.index.title` value  `app/views/books/index.html.erb` template like this (note the dot):

```ruby
<%= t '.title' %>
```

**Note:** Automatic translation scoping by partial is only available from the `translate` view helper method.

##  4.2 Interpolation

In many cases you want to abstract your translations so that . For this reason the I18n API provides an interpolation feature.

All options besides `:default` and `:scope` that are passed to `#translate` will be interpolated to the translation:

```ruby
I18n.backend.store_translations :en, thanks: 'Thanks %{name}!'
I18n.translate :thanks, name: 'Jeremy'
# => 'Thanks Jeremy!'
```

If a translation uses `:default` or `:scope` as an interpolation variable, an `I18n::ReservedInterpolationKey` exception is raised. If a translation expects an interpolation variable, but this has not been passed to `#translate`, an `I18n::MissingInterpolationArgument` exception is raised.

##  4.3 Pluralization

In English there are only one singular and one plural form for a given string, e.g. "1 message" and "2 messages". Other languages ([Arabic](http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html#ar), [Japanese](http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html#ja), [Russian](http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html#ru) and many more) have different grammars that have additional or fewer [plural forms](http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html). Thus, the I18n API provides a flexible pluralization feature.

The `:count` interpolation variable has a special role in that it both is interpolated to the translation and used to pick a pluralization from the translations according to the pluralization rules defined by CLDR:

```ruby
I18n.backend.store_translations :en, inbox: {
  one: 'one message',
  other: '%{count} messages'
}
I18n.translate :inbox, count: 2
# => '2 messages'

I18n.translate :inbox, count: 1
# => 'one message'
```

The algorithm for pluralizations in `:en` is as simple as:

```ruby
entry[count == 1 ? 0 : 1]
```

I.e. the translation denoted as `:one` is regarded as singular, the other is used as plural (including the count being zero).

If the lookup for the key does not return a Hash suitable for pluralization, an `18n::InvalidPluralizationData` exception is raised.

##  4.4 Setting and Passing a Locale

The locale can be either set pseudo-globally to `I18n.locale` (which uses `Thread.current` like, e.g., `Time.zone`) or can be passed as an option to `#translate` and `#localize`.

If no locale is passed, `I18n.locale` is used:

```ruby
I18n.locale = :de
I18n.t :foo
I18n.l Time.now
```

Explicitly passing a locale:

```ruby
I18n.t :foo, locale: :de
I18n.l Time.now, locale: :de
```

The `I18n.locale` defaults to `I18n.default_locale` which defaults to :`en`. The default locale can be set like this:

```ruby
I18n.default_locale = :de
```

##  4.5 Using Safe HTML Translations

Keys with a '_html' suffix and keys named 'html' are marked as HTML safe. When you use them in views the HTML will not be escaped.

```ruby
# config/locales/en.yml
en:
  welcome: <b>welcome!</b>
  hello_html: <b>hello!</b>
  title:
    html: <b>title!</b>
```

```ruby
# app/views/home/index.html.erb
<div><%= t('welcome') %></div>
<div><%= raw t('welcome') %></div>
<div><%= t('hello_html') %></div>
<div><%= t('title.html') %></div>
```

Interpolation escapes as needed though. For example, given:

```ruby
en:
  welcome_html: "<b>Welcome %{username}!</b>"
```

you can safely pass the username as set by the user:

```ruby
<%# This is safe, it is going to be escaped if needed. %>
<%= t('welcome_html', username: @current_user.username %>
```

Safe strings on the other hand are interpolated verbatim.

**Note:** Automatic conversion to HTML safe translate text is only available from the `translate` view helper method.

![](images/i18n/demo_html_safe.png)

##  4.6 Translations for Active Record Models

You can use the methods `Model.model_name.human` and `Model.human_attribute_name(attribute)` to transparently look up translations for your model and attribute names.

For example when you add the following translations:

```ruby
en:
  activerecord:
    models:
      user: Dude
    attributes:
      user:
        login: "Handle"
      # will translate User attribute "login" as "Handle"
```

Then `User.model_name.human` will return "Dude" and `User.human_attribute_name("login")` will return "Handle".

You can also set a plural form for model names, adding as following:

```ruby
en:
  activerecord:
    models:
      user:
        one: Dude
        other: Dudes
```

Then `User.model_name.human(count: 2)` will return "Dudes". With `count: 1` or without params will return "Dude".

In the event you need to access nested attributes within a given model, you should nest these under `model/attribute` at the model level of your translation file:

```ruby
en:
  activerecord:
    attributes:
      user/gender:
        female: "Female"
        male: "Male"
```

Then `User.human_attribute_name("gender.female")` will return "Female".

###  4.6.1 Error Message Scopes

Active Record validation error messages can also be translated easily. Active Record gives you a couple of namespaces where you can place your message translations in order to provide different messages and translation for certain models, attributes, and/or validations. It also transparently takes single table inheritance into account.

This gives you quite powerful means to flexibly adjust your messages to your application's needs.

Consider a User model with a validation for the name attribute like this:

```ruby
class User < ActiveRecord::Base
  validates :name, presence: true
end
```

The key for the error message in this case is `:blank`. Active Record will look up this key in the namespaces:

```ruby
activerecord.errors.models.[model_name].attributes.[attribute_name]
activerecord.errors.models.[model_name]
activerecord.errors.messages
errors.attributes.[attribute_name]
errors.messages
```

Thus, in our example it will try the following keys in this order and return the first result:

```ruby
activerecord.errors.models.user.attributes.name.blank
activerecord.errors.models.user.blank
activerecord.errors.messages.blank
errors.attributes.name.blank
errors.messages.blank
```

When your models are additionally using inheritance then the messages are looked up in the inheritance chain.

For example, you might have an Admin model inheriting from User:

```ruby
class Admin < User
  validates :name, presence: true
end
```

Then Active Record will look for messages in this order:

```ruby
activerecord.errors.models.admin.attributes.name.blank
activerecord.errors.models.admin.blank
activerecord.errors.models.user.attributes.name.blank
activerecord.errors.models.user.blank
activerecord.errors.messages.blank
errors.attributes.name.blank
errors.messages.blank
```

This way you can provide special translations for various error messages at different points in your models inheritance chain and in the attributes, models, or default scopes.

###  4.6.2 Error Message Interpolation

The translated model name, translated attribute name, and value are always available for interpolation.

So, for example, instead of the default error message `"cannot be blank"` you could use the attribute name like this : `"Please fill in your %{attribute}"`.

+ `count`, where available, can be used for pluralization if present:

| validation | with option | message | interpolation |
| ------------- | -------------- |
| confirmation | - | :confirmation | - |
| acceptance | - | :accepted | - |
| presence | - | :blank | - |
| absence | - | :present | - |
| length | :within, :in | :too_short | count |
| length | :within, :in | :too_long | count |
| length | :is | :wrong_length | count |
| length | :minimum | :too_short | count |
| length | :maximum | :too_long | count |
| uniqueness | - | :taken | - |
| format | - | :invalid | - |
| inclusion | - | :inclusion | - |
| exclusion | - | :exclusion | - |
| associated | - | :invalid | - |
| numericality | - | :not_a_number | - |
| numericality | :greater_than | :greater_than | count |
| numericality | :greater_than_or_equal_to | :greater_than_or_equal_to | count |
| numericality | :equal_to | :equal_to | count |
| numericality | :less_than | :less_than | count |
| numericality | :less_than_or_equal_to | :less_than_or_equal_to | count |
| numericality | :only_integer | :not_an_integer | - |
| numericality | :odd | :odd | - |
| numericality | :even | :even | - |

###  4.6.3 Translations for the Active Record `error_messages_for` Helper

If you are using the Active Record `error_messages_for` helper, you will want to add
translations for it.

Rails ships with the following translations:

```ruby
en:
  activerecord:
    errors:
      template:
        header:
          one:   "1 error prohibited this %{model} from being saved"
          other: "%{count} errors prohibited this %{model} from being saved"
        body:    "There were problems with the following fields:"
```

**Note:** In order to use this helper, you need to install [DynamicForm](https://github.com/joelmoss/dynamic_form)
gem by adding this line to your Gemfile: `gem 'dynamic_form'`.

##  4.7 Translations for Action Mailer E-Mail Subjects

If you don't pass a subject to the `mail` method, Action Mailer will try to find
it in your translations. The performed lookup will use the pattern
`<mailer_scope>.<action_name>.subject` to construct the key.

```ruby
# user_mailer.rb
class UserMailer < ActionMailer::Base
  def welcome(user)
    #...
  end
end
```

```ruby
en:
  user_mailer:
    welcome:
      subject: "Welcome to Rails Guides!"
```

To send parameters to interpolation use the `default_i18n_subject` method on the mailer.

```ruby
# user_mailer.rb
class UserMailer < ActionMailer::Base
  def welcome(user)
    mail(to: user.email, subject: default_i18n_subject(user: user.name))
  end
end
```

```ruby
en:
  user_mailer:
    welcome:
      subject: "%{user}, welcome to Rails Guides!"
```

##  4.8 Overview of Other Built-In Methods that Provide I18n Support

Rails uses fixed strings and other localizations, such as format strings and other format information in a couple of helpers. Here's a brief overview.

###  4.8.1 Action View Helper Methods

+ `distance_of_time_in_words` translates and pluralizes its result and interpolates the number of seconds, minutes, hours, and so on. See [datetime.distance_in_words](https://github.com/rails/rails/blob/master/actionview/lib/action_view/locale/en.yml#L4) translations.
+ `datetime_select` and `select_month` use translated month names for populating the resulting select tag. See [date.month_names](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/locale/en.yml#L15) for translations. `datetime_select` also looks up the order option from [date.order](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/locale/en.yml#L18) (unless you pass the option explicitly). All date selection helpers translate the prompt using the translations in the [datetime.prompts](https://github.com/rails/rails/blob/master/actionview/lib/action_view/locale/en.yml#L39) scope if applicable.
+ The `number_to_currency`, `number_with_precision`, `number_to_percentage`, `number_with_delimiter`, and `number_to_human_size` helpers use the number format settings located in the [number](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/locale/en.yml#L37) scope.

###  4.8.2 Active Model Methods

+ `model_name.human` and `human_attribute_name` use translations for model names and attribute names if available in the [activerecord.models](https://github.com/rails/rails/blob/master/activerecord/lib/active_record/locale/en.yml#L36) scope. They also support translations for inherited class names (e.g. for use with STI) as explained above in "Error message scopes".
+ `ActiveModel::Errors#generate_message` (which is used by Active Model validations but may also be used manually) uses `model_name.human` and `human_attribute_name` (see above). It also translates the error message and supports translations for inherited class names as explained above in "Error message scopes".
+ `ActiveModel::Errors#full_messages` prepends the attribute name to the error message using a separator that will be looked up from [errors.format](https://github.com/rails/rails/blob/master/activemodel/lib/active_model/locale/en.yml#L4) (and which defaults to `"%{attribute} %{message}"`).

###  4.8.3 Active Support Methods

+ `Array#to_sentence` uses format settings as given in the [support.array](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/locale/en.yml#L33) scope.

# 5 How to Store your Custom Translations

The Simple backend shipped with Active Support allows you to store translations in both plain Ruby and YAML format.

For example a Ruby Hash providing translations can look like this:

```ruby
{
  pt: {
    foo: {
      bar: "baz"
    }
  }
}
```

The equivalent YAML file would look like this:

```ruby
pt:
  foo:
    bar: baz
```

As you see, in both cases the top level key is the locale. `:foo` is a namespace key and `:bar` is the key for the translation "baz".

Here is a "real" example from the Active Support `en.yml` translations YAML file:

```ruby
en:
  date:
    formats:
      default: "%Y-%m-%d"
      short: "%b %d"
      long: "%B %d, %Y"
```

So, all of the following equivalent lookups will return the `:short` date format `"%b %d"`:

```ruby
I18n.t 'date.formats.short'
I18n.t 'formats.short', scope: :date
I18n.t :short, scope: 'date.formats'
I18n.t :short, scope: [:date, :formats]
```

Generally we recommend using YAML as a format for storing translations. There are cases, though, where you want to store Ruby lambdas as part of your locale data, e.g. for special date formats.

# 6 Customize your I18n Setup

##  6.1 Using Different Backends

For several reasons the Simple backend shipped with Active Support only does the "simplest thing that could possibly work"  ... which means that it is only guaranteed to work for English and, as a side effect, languages that are very similar to English. Also, the simple backend is only capable of reading translations but cannot dynamically store them to any format.

That does not mean you're stuck with these limitations, though. The Ruby I18n gem makes it very easy to exchange the Simple backend implementation with something else that fits better for your needs. E.g. you could exchange it with Globalize's Static backend:

```ruby
I18n.backend = Globalize::Backend::Static.new
```

You can also use the Chain backend to chain multiple backends together. This is useful when you want to use standard translations with a Simple backend but store custom application translations in a database or other backends. For example, you could use the Active Record backend and fall back to the (default) Simple backend:

```ruby
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)
```

##  6.2 Using Different Exception Handlers

The I18n API defines the following exceptions that will be raised by backends when the corresponding unexpected conditions occur:

```ruby
MissingTranslationData       # no translation was found for the requested key
InvalidLocale                # the locale set to I18n.locale is invalid (e.g. nil)
InvalidPluralizationData     # a count option was passed but the translation data is not suitable for pluralization
MissingInterpolationArgument # the translation expects an interpolation argument that has not been passed
ReservedInterpolationKey     # the translation contains a reserved interpolation variable name (i.e. one of: scope, default)
UnknownFileType              # the backend does not know how to handle a file type that was added to I18n.load_path
```

The I18n API will catch all of these exceptions when they are thrown in the backend and pass them to the default_exception_handler method. This method will re-raise all exceptions except for `MissingTranslationData` exceptions. When a `MissingTranslationData` exception has been caught, it will return the exception's error message string containing the missing key/scope.

The reason for this is that during development you'd usually want your views to still render even though a translation is missing.

In other contexts you might want to change this behavior, though. E.g. the default exception handling does not allow to catch missing translations during automated tests easily. For this purpose a different exception handler can be specified. The specified exception handler must be a method on the I18n module or a class with `#call` method:

```ruby
module I18n
  class JustRaiseExceptionHandler < ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(MissingTranslation)
        raise exception.to_exception
      else
        super
      end
    end
  end
end

I18n.exception_handler = I18n::JustRaiseExceptionHandler.new
```

This would re-raise only the `MissingTranslationData` exception, passing all other input to the default exception handler.

However, if you are using `I18n::Backend::Pluralization` this handler will also raise `I18n::MissingTranslationData: translation missing: en.i18n.plural.rule` exception that should normally be ignored to fall back to the default pluralization rule for English locale. To avoid this you may use additional check for translation key:

```ruby
if exception.is_a?(MissingTranslation) && key.to_s != 'i18n.plural.rule'
  raise exception.to_exception
else
  super
end
```

Another example where the default behavior is less desirable is the Rails TranslationHelper which provides the method `#t` (as well as `#translate`). When a `MissingTranslationData` exception occurs in this context, the helper wraps the message into a span with the CSS class `translation_missing`.

To do so, the helper forces `I18n#translate` to raise exceptions no matter what exception handler is defined by setting the `:raise` option:

```ruby
I18n.t :foo, raise: true # always re-raises exceptions from the backend
```

# 7 Conclusion

At this point you should have a good overview about how I18n support in Ruby on Rails works and are ready to start translating your project.

If you find anything missing or wrong in this guide, please file a ticket on our [issue tracker](http://i18n.lighthouseapp.com/projects/14948-rails-i18n/overview). If you want to discuss certain portions or have questions, please sign up to our [mailing list](http://groups.google.com/group/rails-i18n).

# 8 Contributing to Rails I18n

I18n support in Ruby on Rails was introduced in the release 2.2 and is still evolving. The project follows the good Ruby on Rails development tradition of evolving solutions in gems and real applications first, and only then cherry-picking the best-of-breed of most widely useful features for inclusion in the core.

Thus we encourage everybody to experiment with new ideas and features in gems or other libraries and make them available to the community. (Don't forget to announce your work on our [mailing list](http://groups.google.com/group/rails-i18n!))

If you find your own locale (language) missing from our [example translations data](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale) repository for Ruby on Rails, please [fork](https://github.com/guides/fork-a-project-and-submit-your-modifications) the repository, add your data and send a [pull request](https://github.com/guides/pull-requests).

# 9 Resources

+ [Google group: rails-i18n](http://groups.google.com/group/rails-i18n) - The project's mailing list.
+ [GitHub: rails-i18n](https://github.com/svenfuchs/rails-i18n/tree/master) - Code repository for the rails-i18n project. Most importantly you can find lots of [example translations](https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale) for Rails that should work for your application in most cases.
+ [GitHub: i18n](https://github.com/svenfuchs/i18n/tree/master) - Code repository for the i18n gem.
+ [Lighthouse: rails-i18n](http://i18n.lighthouseapp.com/projects/14948-rails-i18n/overview) - Issue tracker for the rails-i18n project.
+ [Lighthouse: i18n](http://i18n.lighthouseapp.com/projects/14947-ruby-i18n/overview) - Issue tracker for the i18n gem.

# 10 Authors

+ [Sven Fuchs](http://www.workingwithrails.com/person/9963-sven-fuchs) (initial author)
+ [Karel Minařík](http://www.workingwithrails.com/person/7476-karel-mina-k)

If you found this guide useful, please consider recommending its authors on [workingwithrails](http://www.workingwithrails.com).

# 11 Footnotes

[1](#footnote-1-ref) Or, to quote [Wikipedia](http://en.wikipedia.org/wiki/Internationalization_and_localization):

[2](#footnote-2-ref) Other backends might allow or require to use other formats, e.g. a GetText backend might allow to read GetText files.

[3](#footnote-3-ref) One of these reasons is that we don't want to imply any unnecessary load for applications that do not need any I18n capabilities, so we need to keep the I18n library as simple as possible for English. Another reason is that it is virtually impossible to implement a one-fits-all solution for all problems related to I18n for all existing languages. So a solution that allows us to exchange the entire implementation easily is appropriate anyway. This also makes it much easier to experiment with custom features and extensions.

# Feedback

You're encouraged to help improve the quality of this guide.

Please contribute if you see any typos or factual errors.
          To get started, you can read our [documentation contributions](http://edgeguides.rubyonrails.org/contributing_to_ruby_on_rails.html#contributing-to-the-rails-documentation) section.

You may also find incomplete content, or stuff that is not up to date.
          Please do add any missing documentation for master. Make sure to check
          [Edge Guides](http://edgeguides.rubyonrails.org) first to verify
          if the issues are already fixed or not on the master branch.
          Check the [Ruby on Rails Guides Guidelines](ruby_on_rails_guides_guidelines.html)
          for style and conventions.

If for whatever reason you spot something to fix but cannot patch it yourself, please
          [open an issue](https://github.com/rails/rails/issues).

And last but not least, any kind of discussion regarding Ruby on Rails
          documentation is very welcome in the [rubyonrails-docs mailing list](http://groups.google.com/group/rubyonrails-docs).

