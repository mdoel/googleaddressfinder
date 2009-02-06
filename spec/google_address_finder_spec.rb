require File.dirname(__FILE__) + '/../lib/google_address_finder.rb'

describe GoogleAddressFinder do
  
  before(:all) do
    @default_finder = GoogleAddressFinder.new
    @default_addresses = @default_finder.all_addresses
  end
  
  it "should provide addresses using nothing but defaults" do
    a = @default_finder.get_random_address
    a.should_not be_nil
  end
  
  it "should allow the user to provide a specific search term" do
    s = GoogleAddressFinder.new(:search_term => 'church')
    a = s.get_random_address
    churches = s.all_addresses
    churches.first.should_not eql(@default_addresses.first)
  end

  it "should allow the user to provide a specific set of locations to search" do
    s = GoogleAddressFinder.new(:locations => ['43220'])
    a = s.get_random_address
    columbus = s.all_addresses
    columbus.first.should_not eql(@default_addresses.first)
  end
  
  it "should allow the user to provide a specific number of results per location" do
    s = GoogleAddressFinder.new(:per_location => 1)
    a = s.get_random_address
    short_list = s.all_addresses
    short_list.size.should_not eql(@default_addresses.size)
  end

  it "should allow the user to provide a limit of google hits per location" do
    s = GoogleAddressFinder.new(:max_hits_per_location => 1, :per_location => 30, :locations => ['43220'])
    a = s.get_random_address
    s.should have(10).all_addresses
  end
  
end
