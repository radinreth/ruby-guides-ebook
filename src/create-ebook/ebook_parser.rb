require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'net/http'
require 'fileutils'

class EbookParser
  attr_reader :url

  def initialize(url)
    @url = url
    @page = Nokogiri::HTML(open(url))
  end

  def create_file name
    path = name.gsub(' ', '_').downcase
    @dir = File.dirname(path)
    FileUtils.mkdir_p @dir

    @f = File.new(path + '.md', 'w+')
  end

  def get_title
    @page.css('div#feature')[0].css('.wrapper').css('h2').text
  end

  def make_header
    # create title block
    write "---\n"
    write "title: #{get_title}\n"
    write "author: Ruby on Rails\n"
    write "rights: Creative Commons Attribution-ShareAlike 4.0 International\n"
    write "language: en-US\n"
    write "...\n\n"

    feature = @page.css('div#feature')[0].css('.wrapper')

    write "# #{get_title}\n\n"
    write feature.css('p')[0].text + "\n" unless feature.css('p')[0].nil?
    write feature.css('p')[1].text + "\n\n" unless feature.css('p')[1].nil?

    unless feature.css('ul')[0].nil?
      lis = feature.css('ul')[0].css('li')
      lis.each do |li|
        write "+ #{li.text}\n"
      end
    end

    write "\n\n"
  end

  def make_body
    body = @page.css('#mainCol')

    body.children.each do |node|
      process_node node
    end
  end

  def create_bat name
    name = name.gsub(' ', '_').downcase + '.bat'
    bat = File.new(name, 'w+')

    filename = File.basename name, File.extname(name)

    bat.write "..\\..\\..\\..\\..\\tools\\Pandoc\\pandoc.exe --css '..\\..\\..\\..\\..\\styles\\tables.css' -o #{filename}.epub #{filename}.md\n\n"
    bat.write "..\\..\\..\\..\\..\\tools\\calibre\\ebook-convert.exe #{filename}.epub #{filename}.mobi\n\n"
    bat.write "..\\..\\..\\..\\..\\tools\\calibre\\ebook-convert.exe #{filename}.epub #{filename}.pdf\n\n"
    bat.write 'pause'

    name
  end

  private
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

    # table
    return write process_table node if node.name == 'table'


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
      result += "`#{child.text}`" if child.name == 'code'
      result += "[#{child.text.strip}](#{child.attr(:href)})" if child.name == 'a'

      result += "#{process_text child}\n\n" if child.name == 'p'
      result += "#{process_code child}\n\n" if child.name == 'div' && child.attr(:class) == 'code_container'

      result += "#{process_img child}" if child.name == 'img'
    end

    result.strip
  end

  def process_img node
    alt = node.attr(:alt)

    uri = URI.parse @url

    # check if directory is exist
    src = File.join(@dir, node.attr(:src))
    dirname = File.dirname(src)
    unless File.directory?(dirname)
      FileUtils.mkdir_p dirname
    end

    Net::HTTP.start(uri.host) do |http|
      resp = http.get('/' + node.attr(:src))
      open(src, "wb") do |file|
        file.write(resp.body)
      end
    end

    # "![#{alt.nil? ? 'empty' : alt}](#{src})"
    "![](#{node.attr(:src)})"
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

  def process_table node
    ths = node.css('thead').css('th')

    result = "|"
    ths.each do |th|
      result += " #{th.text} |"
    end
    result += "\n| ------------- | -------------- |\n"

    trs = node.css('tbody').css('tr')
    trs.each do |tr|
      result += '|'
      tr.css('td').each do |td|
        result += " #{td.text} |"
      end
      result += "\n"
    end
    result += "\n"

    #puts result

    result
  end

  def write text
    #puts text
    @f.write text
  end
end