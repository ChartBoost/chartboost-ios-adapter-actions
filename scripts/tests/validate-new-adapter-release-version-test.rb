# Tests for validate-new-adapter-release-version.rb

require_relative 'test-common'

test('../validate-new-adapter-release-version.rb', ['4.3.2.0.3'], 0)
test('../validate-new-adapter-release-version.rb', ['4.3.2.0.3.2'], 0)
test('../validate-new-adapter-release-version.rb', ['2.4.3.0'], 1)
test('../validate-new-adapter-release-version.rb', ['2.4.3'], 1)
test('../validate-new-adapter-release-version.rb', ['2.4'], 1)
test('../validate-new-adapter-release-version.rb', ['2'], 1)
test('../validate-new-adapter-release-version.rb', ['asdf'], 1)
test('../validate-new-adapter-release-version.rb', [''], 1)
