require_relative 'test_helper'

class SsoTest < IntegrationTestCase

  def setup
    super
    @resource = Fabricate(:resource)
  end

  def test_sso_page
    sso! @resource.id
    assert page.has_content? "The Addon"
    assert page.has_content? @resource.plan
  end
end
