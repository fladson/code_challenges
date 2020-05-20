require 'rails_helper'

describe 'routes' do
  specify { expect(get: '/').to route_to(controller: 'public_repositories', action: 'index') }
  specify { expect(post: '/search').to route_to(controller: 'public_repositories', action: 'search') }
end
