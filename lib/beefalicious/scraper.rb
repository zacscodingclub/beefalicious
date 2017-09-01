require 'pry'

class Beefalicious::Scraper
  BASE_URL = 'https://www.localharvest.org/'

  def self.scrape_list
    doc = Nokogiri::HTML(open(BASE_URL + 'search.jsp?&ty=0&nm=beef'))
    values = []
    first = doc.css('.sortby span b')[0].text.to_i
    last = doc.css('.sortby span b')[1].text.to_i

    first.upto(2) do |i|
      puts "Scraping page #{i} of #{last}"
      values << scrape_page(i)
    end

    values.flatten
  end

  def self.scrape_page(page_number)
    page = Nokogiri::HTML(open(BASE_URL + "search.jsp?&ty=0&nm=beef&p=#{page_number}"))

    page.css('.membercell').map do |member|
      link = member.css('a')[0]
      attributes = {
        name: link.text,
        url: BASE_URL + link.attr('href')
      }

      attributes
    end
  end

  def self.scrape_ranch(ranch)
    page = Nokogiri::HTML(open(ranch[:url]))

    sidebar = page.css('.sidebar')

    contact_name, contact_phone = get_contact_info(sidebar.css('.tab div span'))
    ranch[:address] = get_address(sidebar.css('.tab~ .tab div'))
    ranch[:website] = get_website_url(sidebar.css('.tab a'))
    ranch[:facebook] = get_website_url(sidebar.css('br+ a'))
    ranch[:contact_name] = contact_name
    ranch[:contact_phone] = contact_phone

    ranch
  end

  def self.get_contact_info(el)
    el.size > 1 ? [
      el[0].text,
      el[1].text
    ] : [
      el[0].text,
      nil
    ]
  end

  def self.get_address(el)
    el.text.gsub(/\n/, '').strip.split(/\W{3,}/).join(';')
  end

  def self.get_website_url(el)
    el.attr('href') ? el.attr('href').value : nil
  end
end
