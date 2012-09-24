require 'spec_helper'

describe Request do

  it 'Creates a Request' do
    Request.create(:req_type => "test", :params => "test")
  end

end

