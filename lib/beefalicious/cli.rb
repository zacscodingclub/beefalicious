class Beefalicious::CLI
  def call
    load_farms

    save_farms
  end

  def load_farms
    list = Beefalicious::Scraper.scrape_list
    size = list.count
    list.each.with_index do |item, index|
      puts "Scraping Ranch #{index + 1} of #{size}"
      attributes = Beefalicious::Scraper.scrape_ranch(item)
      ranch = Ranch.new(attributes)
      # "#{name}, #{contact_name}, #{contact_phone}, #{address}, #{website}, #{facebook}, #{url}"

      sleep(rand(5..30))
    end

    binding.pry
  end

  def save_farms
    puts "Saving them farms!!"
  end
end
