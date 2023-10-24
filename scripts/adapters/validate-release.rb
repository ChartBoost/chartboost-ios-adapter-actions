# Runs validations before releasing a new version of an adapter.

require_relative 'common'

# Parse the version string from the arguments
abort "Missing argument. Requires: version string." unless ARGV.count == 1
version = ARGV[0]

# Validate that the changelog contains an entry for the version to be released.
changelog = read_changelog
regex = /^### #{version}$/m
abort "Release validation failed: entry for #{version} not found in the CHANGELOG." unless changelog.match?(regex)
