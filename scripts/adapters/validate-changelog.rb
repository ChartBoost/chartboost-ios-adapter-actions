# Validates that a changelog entry exists for the adapter version.

require_relative 'common'

# Validate that the changelog contains an entry for the version to be released.
changelog = read_changelog
version = podspec_version
regex = /^### #{version}$/m
abort "Release validation failed: entry for #{version} not found in the CHANGELOG." unless changelog.match?(regex)
