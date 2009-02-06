require 'hpricot'
require 'open-uri'
require 'cgi'

class GoogleAddressFinder
  attr_reader :locations, :all_addresses
  
  TOP_CITIES = ['New York City, NY',
                'Los Angeles, CA',
                'Chicago, IL',
                'Houston, TX',
                'Philadelphia, PA',
                'Phoenix, AZ',
                'San Antonio, TX',
                'San Diego, CA',
                'Dallas, TX',
                'San Jose, CA'
  ]
  
  def initialize(options = {})
    @locations = options[:locations] || TOP_CITIES
    @term = options[:search_term] || "mcdonalds"
    @results_per_location = options[:per_location] || 10
    @max_hits_per_location = options[:max_hits_per_location] || 2
    @all_addresses = []
  end
  
  def load_addresses
    @locations.each do |location|
      count = 0
      page = 0
      while count < @results_per_location && page < @max_hits_per_location
        url = url_for(location,page*10)
        doc = Hpricot(open(url))
        addresses = doc/"span.street-address"
        addresses.each do |a|
          full_address = a.inner_html + ", #{location}"
          if full_address =~ /\d+/ && !@all_addresses.include?(full_address) && count < @results_per_location
            @all_addresses << full_address
            count = count + 1
          end
        end
        page = page + 1
      end
    end
  end
  
  def get_random_address
    load_addresses if @all_addresses.empty?
    @all_addresses[rand(@all_addresses.size)]
  end
  
  def url_for(location, start=0)
    "http://maps.google.com/maps?q=#{@term}%20" + CGI::escape(location) + "&start=#{start}"
  end
  
end
