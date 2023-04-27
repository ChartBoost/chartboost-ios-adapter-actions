# Tests for validate-adapter-and-partner-versions.rb

require_relative 'test-common'

test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.0', '3.2.0'], 0)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.3', '3.2.0'], 0)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.3', '~> 3.2.0'], 0)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.3.2', '3.2.0.3'], 0)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.3.2', '~> 3.2.0.3'], 0)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.0', '3.1.0'], 1)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.1.2.0.0', '3.1.0'], 1)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.0', '3.2.1'], 1)
test('../adapters/validate-adapter-and-partner-versions.rb', ['4.3.2.0.0', '~> 3.2.1'], 1)
