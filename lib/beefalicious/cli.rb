class Beefalicious::CLI
  def call
    load_farms

    save_farms
  end

  def load_farms
    list = Beefalicious::Scraper.scrape_list

    list.each do |item|
      attributes = Beefalicious::Scraper.scrape_ranch(item)

      Ranch.new(attributes)
    end

    binding.pry
  end

  def save_farms
    puts "Saving them farms!!"
  end
end
