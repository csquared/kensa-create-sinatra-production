require_relative 'test_helper'

class ProvisionTest < RackTestCase
  #test unauthorized requests with kensa
  def setup
    super 
    basic_auth!
  end

  def test_provision
    provision!
    assert_equal 201, last_response.status
  end
end
