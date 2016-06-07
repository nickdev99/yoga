# require 'path/to/ip2location_lib'

module LocalEngine
  module Geolocation
    # Location of the IP2Location database
    DATABASE = 'path/to/ip2location_database'
    
    extend self
    
    # Tries to determine the location (city and province)
    # of an IP address.
    #
    # @param [String] ip an IP address
    #
    # @return [Array] an array of [city, province] if found
    # @return [nil] if city + province are not found
    def lookup(ip)
      # Check that the IP address is a string
      raise ArgumentError, "String required but got #{ip.class}" unless String === ip
      
      # Search for city and region information
      loc  = locator.get_all(ip)
      city = loc.city
      prov = loc.region
      
      # If city and region information was found, return them
      # as an array. If only one, or neither, was found, return nil.
      city && prov ? [city, proc] : nil
    end
    
    private
    # Memoizes an IP2Location object. We only need one of
    # these objects for the whole app (this saves memory).
    #
    # @return [IP2Location]    
    def locator
      @locator ||= create_locator      
    end
    
    # Creates a new IP2Location object and reads in the data
    # from the IP2Location database.
    #
    # @return [IP2Location]
    def create_locator
      returning IP2Location.new do |locator|
        locator.open(DATABASE)
      end
    end
  end
end