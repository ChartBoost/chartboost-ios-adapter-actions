# Tests for validate-partner-version.rb

require_relative 'test-common'

test('../adapters/validate-partner-version.rb', ['3.0.0'], 0)
test('../adapters/validate-partner-version.rb', ['~> 3.0.0'], 0)
test('../adapters/validate-partner-version.rb', ['~> 2.4'], 0)
test('../adapters/validate-partner-version.rb', ['asdf'], 1)
test('../adapters/validate-partner-version.rb', [''], 1)
