# http://ruby.bastardsbook.com/chapters/html-parsing/

require 'fileutils'
require './ebook_parser'

prefix = 'books/'

urls = {'http://guides.rubyonrails.org/getting_started.html' => "#{prefix}Start Here/Getting Started with Rails",

        'http://guides.rubyonrails.org/active_record_basics.html' => "#{prefix}Model/Active Record Basics",
        'http://guides.rubyonrails.org/active_record_migrations.html' => "#{prefix}Model/Active Record Migrations",
        'http://guides.rubyonrails.org/active_record_validations.html' => "#{prefix}Model/Active Record Validations",
        'http://guides.rubyonrails.org/active_record_callbacks.html' => "#{prefix}Model/Active Record Callbacks",
        'http://guides.rubyonrails.org/association_basics.html' => "#{prefix}Model/Active Record Associations",
        'http://guides.rubyonrails.org/active_record_querying.html' => "#{prefix}Model/Active Record Query Interface",

        'http://guides.rubyonrails.org/layouts_and_rendering.html' => "#{prefix}Views/Layouts and Rendering in Rails",
        'http://guides.rubyonrails.org/form_helpers.html' => "#{prefix}Views/Action View Form Helper",

        'http://guides.rubyonrails.org/action_controller_overview.html' => "#{prefix}Controllers/Action Controller Overview",
        'http://guides.rubyonrails.org/routing.html' => "#{prefix}Controllers/Rails Routing from the Outside In",

        'http://guides.rubyonrails.org/active_support_core_extensions.html' => "#{prefix}Digging Deeper/Active Support Core Extensions",
        'http://guides.rubyonrails.org/i18n.html' => "#{prefix}Digging Deeper/Rails Internationalization API",
        'http://guides.rubyonrails.org/action_mailer_basics.html' => "#{prefix}Digging Deeper/Action Mailer Basics",
        'http://guides.rubyonrails.org/active_job_basics.html' => "#{prefix}Digging Deeper/Active Job Basics",
        'http://guides.rubyonrails.org/security.html' => "#{prefix}Digging Deeper/Securing Rails Applications",
        'http://guides.rubyonrails.org/debugging_rails_applications.html' => "#{prefix}Digging Deeper/Debugging Rails Applications",
        'http://guides.rubyonrails.org/configuring.html' => "#{prefix}Digging Deeper/Configuring Rails Applications",
        'http://guides.rubyonrails.org/command_line.html' => "#{prefix}Digging Deeper/Rails Command Line Tools and Rake Tasks",
        'http://guides.rubyonrails.org/asset_pipeline.html' => "#{prefix}Digging Deeper/Asset Pipeline",
        'http://guides.rubyonrails.org/working_with_javascript_in_rails.html' => "#{prefix}Digging Deeper/Working with JavaScript in Rails",
        'http://guides.rubyonrails.org/constant_autoloading_and_reloading.html' => "#{prefix}Digging Deeper/Constant Autoloading and Reloading",

        'http://guides.rubyonrails.org/rails_on_rack.html' => "#{prefix}Extending Rails/Rails on Rack",
        'http://guides.rubyonrails.org/generators.html' => "#{prefix}Extending Rails/Creating and Customizing Rails Generators",

        'http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html' => "#{prefix}Contributing to Ruby on Rails/Contributing to Ruby on Rails",
        'http://guides.rubyonrails.org/api_documentation_guidelines.html' => "#{prefix}Contributing to Ruby on Rails/API Documentation Guidelines",
        'http://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html' => "#{prefix}Contributing to Ruby on Rails/Ruby on Rails Guides Guidelines",

        'http://guides.rubyonrails.org/maintenance_policy.html' => "#{prefix}Maintenance Policy/Maintenance Policy"}

def create_ebooks url
  link = url[0]
  dir = url[1]

  # FileUtils.mkdir_p dir # create dir

  parser = EbookParser.new link

  print "Create file..."
  parser.create_file File.join(dir, parser.get_title)
  puts "done."

  print 'Make header....'
  parser.make_header
  puts 'done.'

  print 'Make body...'
  parser.make_body
  puts 'done.'

  print "Create .bat file..."
  bat_path = parser.create_bat File.join(dir, parser.get_title)
  puts bat_path
  puts 'done.'
end

# parser = EbookParser.new 'http://guides.rubyonrails.org/layouts_and_rendering.html'

# first = urls.first
# path = first[1]
# puts path


urls.each do |url|
  create_ebooks url
end

# urls.keys.each do |key|
#   puts key
# end

# create_ebooks urls.first

puts 'Everything is done.'