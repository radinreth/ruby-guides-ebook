require 'rubygems'
require 'nokogiri'
require 'open-uri'

class EbookParser
  attr_reader :url

  def initialize(url)
    @url = url
    @page = Nokogiri::HTML(open(url))
  end

  def create_file name
    @f = File.new(name.gsub(' ', '_').downcase + '.md', 'w+')
    write "Autocreated at #{Time.now.to_s}\n\n"
  end

  def get_title
    @page.css('div#feature')[0].css('.wrapper').css('h2').text
  end

  def make_header
    feature = @page.css('div#feature')[0].css('.wrapper')

    write "# #{get_title}\n\n"
    write feature.css('p')[0].text + "\n"
    write feature.css('p')[1].text + "\n\n"

    lis = feature.css('ul')[0].css('li')
    lis.each do |li|
      write "+ #{li.text}\n"
    end

    write "\n\n"
  end

  def make_body
    body = @page.css('#mainCol')

    # old variant
    body.children.each do |node|
      process_node node
    end

    # new variant
    # body.children.each do |node| # first hierarchy
    #   process node
    #   puts node.name
    # end
  end

  private
  def process node
    #return if node.text.empty?
    return @f.write node.text if node.name == 'text' && (not node.text.strip.empty?)

    # before
    case node.name
      when 'h3'
        @f.write "\n\n# "
      when 'h4'
        @f.write "\n\n## "
      when 'h5'
        @f.write "\n\n### "
      when 'h6'
        @f.write "\n\n#### "
      when 'li'
        @f.write "\n+ "
      when 'code'
        @f.write '*'
      when 'ul'
        @f.write "\n"
      when 'p'
        @f.write "\n\n"
    end

    # process children
    node.children.each do |child|
      process child
    end

    # after
    # case node.name
    #   when 'h3', 'h4', 'h5', 'h6', 'p'
    #     @f.write "\n\n"
    #   when 'li'
    #     @f.write "\n"
    #   when 'code'
    #     @f.write '* '
    # end

    # if node.name == 'h3'
    #   @f.write '#'
    #   node.children.each do |child|
    #     process child
    #   end
    #   @f.write "\n\n"
    # end

  end

  def process_node node
    #return if node.text.empty?

    #puts "#{node.name} : #{node.text}"
    # puts node.name

    # headers
    return write("# #{process_text node}\n\n") if node.name == 'h3'
    return write("##  #{process_text node}\n\n") if node.name == 'h4'
    return write("###  #{process_text node}\n\n") if node.name == 'h5'
    return write("####  #{process_text node}\n\n") if node.name == 'h6'

    return write("#{process_text node}\n\n") if node.name == 'p'

    # lists
    return process_ul node if node.name == 'ul'

    # ruby code
    return write process_code node if node.name == 'div' && node.attr(:class) == 'code_container'

    return write process_note node if node.name == 'div' && node.attr(:class) == 'note'
    return write process_info node if node.name == 'div' && node.attr(:class) == 'info'
    return write process_warning node if node.name == 'div' && node.attr(:class) == 'warning'

    # node.children.each do |child|
    #   traverse_each child
    # end
  end

  def process_ul ul
    ul.css('li').each do |li|
      write("+ #{process_text li}\n")
    end

    write "\n"
  end

  def process_text txt
    #str.gsub('<code>', '*').gsub('</code>', '*')

    #puts txt.text + ' : ' + txt.children.length.to_s
    result = ''
    txt.children.each do |child|
      result += child.text if child.name == 'text'
      result += "*#{child.text}*" if child.name == 'code'
      result += "[#{child.text.strip}](#{child.attr(:href)})" if child.name == 'a'

      result += "#{process_text child}\n\n" if child.name == 'p'
      # result += "#{process_code child}\n\n" if child.name == 'div' && child.attr(:class) == 'code_container'
      if child.name == 'div' && child.attr(:class) == 'code_container'
        result += "#{process_code child}\n\n"
      end
    end

    result.strip
  end

  def process_code node
    content = node.text.strip

    "```ruby\n#{content}\n```\n\n"
  end

  def process_note node
    content = process_text node.css('p')

    "**Note:** #{content}\n\n"
  end

  def process_info node
    content = process_text node.css('p')

    "**Info:** #{content}\n\n"
  end

  def process_warning node
    content = process_text node.css('p')

    "**Warning:** #{content}\n\n"
  end

  def write text
    puts text
    @f.write text
  end
end