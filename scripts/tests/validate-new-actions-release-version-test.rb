# Tests for validate-new-actions-release-version.rb

require_relative 'test-common'

test('../validate-new-actions-release-version.rb', ['v99.3.2'], 0)
test('../validate-new-actions-release-version.rb', ['v1.9999.2'], 0)
test('../validate-new-actions-release-version.rb', ['v1.0.0'], 1) # already existing tag
test('../validate-new-actions-release-version.rb', ['3.0.99'], 1)
test('../validate-new-actions-release-version.rb', ['3.0'], 1)
test('../validate-new-actions-release-version.rb', ['v3.0'], 1)
