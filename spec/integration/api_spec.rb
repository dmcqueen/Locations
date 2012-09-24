require 'spec_helper'

describe 'API Calls to /api/location?query=...&near=...' do

  it 'Asks for location "sushi" and checks for foursquare data' do
    visit '/api/location?query=sushi&near=San+Francisco'
    page.should have_content('foursquare')
  end

  it 'Asks for location "sushi" and checks for google data' do
    visit '/api/location?query=sushi&near=San+Francisco'
    page.should have_content('google')
  end

end

