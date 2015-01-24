# http://ruby.bastardsbook.com/chapters/html-parsing/

require './ebook_parser'

parser = EbookParser.new 'http://guides.rubyonrails.org/layouts_and_rendering.html'


print 'Make header....'
parser.make_header
puts 'done.'

print 'Make body...'
parser.make_body
puts 'done.'


puts 'Everything is done.'