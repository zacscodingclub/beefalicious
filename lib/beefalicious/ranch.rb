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

  def self.to_csv

  end
end
