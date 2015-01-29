---
title: Ruby on Rails Guides Guidelines
author: Ruby on Rails
rights: Creative Commons Attribution-ShareAlike 4.0 International
language: en-US
...

# Ruby on Rails Guides Guidelines

This guide documents guidelines for writing Ruby on Rails Guides. This guide follows itself in a graceful loop, serving itself as an example.
After reading this guide, you will know:

+ About the conventions to be used in Rails documentation.
+ How to generate guides locally.


# 1 Markdown

Guides are written in [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown). There is comprehensive [documentation for Markdown](http://daringfireball.net/projects/markdown/syntax), as well as a [cheatsheet](http://daringfireball.net/projects/markdown/basics).

# 2 Prologue

Each guide should start with motivational text at the top (that's the little introduction in the blue area). The prologue should tell the reader what the guide is about, and what they will learn. As an example, see the [Routing Guide](routing.html).

# 3 Headings

The title of every guide uses an `h1` heading; guide sections use `h2` headings; subsections use `h3` headings; etc. Note that the generated HTML output will use heading tags starting with `<h2>`.

```ruby
Guide Title
===========

Section
-------

### Sub Section
```

When writing headings, capitalize all words except for prepositions, conjunctions, internal articles, and forms of the verb "to be":

```ruby
#### Middleware Stack is an Array
#### When are Objects Saved?
```

Use the same inline formatting as regular text:

```ruby
##### The `:content_type` Option
```

# 4 API Documentation Guidelines

The guides and the API should be coherent and consistent where appropriate. In particular, these sections of the [API Documentation Guidelines](api_documentation_guidelines.html) also apply to the guides:

+ [Wording](api_documentation_guidelines.html#wording)
+ [English](api_documentation_guidelines.html#english)
+ [Example Code](api_documentation_guidelines.html#example-code)
+ [Filenames](api_documentation_guidelines.html#file-names)
+ [Fonts](api_documentation_guidelines.html#fonts)

# 5 HTML Guides

Before generating the guides, make sure that you have the latest version of Bundler installed on your system. As of this writing, you must install Bundler 1.3.5 on your device.

To install the latest version of Bundler, run `gem install bundler`.

##  5.1 Generation

To generate all the guides, just `cd` into the `guides` directory, run `bundle install`, and execute:

```ruby
bundle exec rake guides:generate
```

or

```ruby
bundle exec rake guides:generate:html
```

To process `my_guide.md` and nothing else use the `ONLY` environment variable:

```ruby
touch my_guide.md
bundle exec rake guides:generate ONLY=my_guide
```

By default, guides that have not been modified are not processed, so `ONLY` is rarely needed in practice.

To force processing all the guides, pass `ALL=1`.

It is also recommended that you work with `WARNINGS=1`. This detects duplicate IDs and warns about broken internal links.

If you want to generate guides in a language other than English, you can keep them in a separate directory under `source` (eg. `source/es`) and use the `GUIDES_LANGUAGE` environment variable:

```ruby
bundle exec rake guides:generate GUIDES_LANGUAGE=es
```

If you want to see all the environment variables you can use to configure the generation script just run:

```ruby
rake
```

##  5.2 Validation

Please validate the generated HTML with:

```ruby
bundle exec rake guides:validate
```

Particularly, titles get an ID generated from their content and this often leads to duplicates. Please set `WARNINGS=1` when generating guides to detect them. The warning messages suggest a solution.

# 6 Kindle Guides

##  6.1 Generation

To generate guides for the Kindle, use the following rake task:

```ruby
bundle exec rake guides:generate:kindle
```

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

