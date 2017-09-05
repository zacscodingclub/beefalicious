class Ranch
  attr_accessor :name,
                :url,
                :contact_name,
                :contact_phone,
                :address,
                :website,
                :facebook

  @@all = []

  def initialize(attributes)
    set_attributes(attributes)

    @@all << self

    File.open('./tmp/results.txt', 'a') do |f|
      f << self.to_s
    end
  end

  def set_attributes(attributes)
    attributes.each { |k, v| self.send(("#{k}="), v) }
  end

  def add_attributes(attributes)
    set_attributes(attributes)
  end

  def self.all
    @@all
  end

  def to_s
    "#{name}, #{contact_name}, #{contact_phone}, #{address}, #{website}, #{facebook}, #{url}\n"
  end
end
