require 'pry'
require 'mechanize'
require 'socksify'

class Beefalicious::Scraper
  BASE_URL = 'https://www.localharvest.org'

  class << self

    def socks_request(url)
      user_agent = Mechanize::AGENT_ALIASES.keys.sample

      Socksify::proxy("127.0.0.1", 9050) {
        open(url, 'User-Agent' => user_agent)
      }
    end

    def scrape_list
      uri = URI.parse(BASE_URL + 'search.jsp?&ty=0&nm=beef')
      doc = socks_request(uri)

      values = []
      first = doc.css('.sortby span b')[0].text.to_i
      last = doc.css('.sortby span b')[1].text.to_i

      first.upto(last) do |i|
        puts "Scraping page #{i} of #{last}"
        values << scrape_page(i)

        sleep(rand(5..30))
      end

      values.flatten
    end

    def scrape_page(page_number)
      uri = URI.parse(BASE_URL+ "/search.jsp?&ty=0&nm=beef&p=#{page_number}")
      html = socks_request(uri)

      page = Nokogiri::HTML(html)

      m = page.css('.membercell').map do |member|
        link = member.css('a')[0]
        attributes = {
          name: link.text,
          url: BASE_URL + link.attr('href')
        }

        attributes
      end
      size = m.size

      m.each.with_index do |r, i|
        puts "Scraping #{i} of #{size}"
        begin
          Ranch.new(scrape_ranch(r))
          sleep(rand(2..25))
        rescue
          puts "*"* 30
          puts "Scraping of Ranch #{i} failed!!"
          puts "*" * 30
        end
      end

    end

    def scrape_ranch(ranch)
      uri = URI.parse(ranch[:url])
      html = html = socks_request(uri)

      page = Nokogiri::HTML(html)

      sidebar = page.css('.sidebar')

      contact_name, contact_phone = get_contact_info(sidebar.css('.tab div span'))
      ranch[:address] = get_address(sidebar.css('.tab~ .tab div')) if sidebar.at_css('.tab~ .tab div')
      ranch[:website] = get_website_url(sidebar.css('.tab a')) if sidebar.at_css('.tab a')
      ranch[:facebook] = get_website_url(sidebar.css('br+ a')) if sidebar.at_css('bar+ a')
      ranch[:contact_name] = contact_name
      ranch[:contact_phone] = contact_phone

      ranch
    end

    def get_contact_info(el)
      el.size > 1 ? [
        el[0].text,
        el[1].text
      ] : [
        el[0].text,
        nil
      ]
    end

    def get_address(el)
      el.text.gsub(/\n/, '').strip.split(/\W{3,}/).join(';')
    end

    def get_website_url(el)
      el.attr('href') ? el.attr('href').value : nil
    end
  end
end
