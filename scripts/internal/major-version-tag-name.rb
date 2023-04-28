# Prints the name for a major version tag given a release version tag string.
# E.g. with "v1.2.0" it will print out "v1".

RELEASE_VERSION_TAG_REGEX = /^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/

# Parse the version string from the arguments
abort "Missing argument. Requires: version tag string." unless ARGV.count == 1
version = ARGV[0]

match = RELEASE_VERSION_TAG_REGEX.match(version)

# Fail if the provided string isn't a proper version tag.
abort "Invalid input: #{version} is not a 3-digit tag name with a 'v' prefix." unless match

# Output major digit version.
puts "v#{match[1]}"
