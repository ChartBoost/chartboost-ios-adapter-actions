# Updates the adapter minimum OS version based on the partner SDK minimum.

require_relative 'common'
require 'json'
require 'open3'

def sdk_min_os_version
  return Gem::Version.new('13.0')
end

# Function to obtain the min OS version info from the partner podspec
def min_os_version(pod_name, pod_version)

  # Update cocoapods repos to ensure the local info is up to date
  `pod repo add-cdn trunk https://cdn.cocoapods.org`
  `pod repo update`
  
  # Use the `pod spec cat` command to get the podspec as JSON
  stdout_str, stderr_str, status = Open3.capture3('pod', 'spec', 'cat', pod_name, "--version=#{pod_version}")
  unless status.success?
    abort "`pod spec cat` error: #{stdout_str} #{stderr_str}"
  end
  podspec_json = stdout_str

  begin
    podspec = JSON.parse(podspec_json)
  rescue => error
    abort "JSON parsing failed. Error: #{error.message}. Invalid JSON: '#{podspec_json}'"
  end
  
  # Extract the platform information; assuming iOS here
  min_os_version = podspec['platforms']['ios']
  
  # Return the version string
  min_os_version
end

# Parse the partner version string from the arguments
abort "Missing argument. Requires: partner version." unless ARGV.count == 1
partner_version = ARGV[0]

# Sanitize partner version string used to fetch the podspec info
partner_version = partner_version.delete_prefix('~> ')

# Obtain the min OS versions for the current adapter and the desired partner version
# Convert to `Gem::Version`, otherwise the string '2.0' is greater than '11.0'.
partner_min_os_version = Gem::Version.new(in_os_version(podspec_partner_sdk_name(), partner_version))
current_adapter_version = Gem::Version.new(podspec_min_os_version())
# Always choose the max of `sdk_min_os_version` and `partner_min_os_version`, so that we never
# downgrade below the `sdk_min_os_version`.
new_min_os_version = [sdk_min_os_version, partner_min_os_version].max

# Keep a list of modified files to output at the end
modified_files = []

# Update adapter files with the new min OS version if it's greater than the current version.
if new_min_os_version != current_adapter_version
  # Read the podspec file
  podspec = read_podspec()
  # Replace the min OS version string (capture group 2), keeping everything else the same (capture groups 1 and 3)
  podspec = podspec.sub(PODSPEC_MIN_OS_VERSION_REGEX, "\\1#{new_min_os_version}\\3")
  # Write the changes
  write_podspec(podspec)
  modified_files.append(podspec_file_path)

  # Read the readme file
  readme = read_readme()
  # Replace the min OS version string (capture group 2), keeping everything else the same (capture groups 1 and 3)
  readme = readme.sub(README_MIN_OS_VERSION_REGEX, "\\1#{new_min_os_version}\\3")
  # Write the changes
  write_readme(readme)
  modified_files.append(readme_file_path)

  # Read the changelog file
  changelog = read_changelog()
  # Add a note to the corresponding entry
  entry_header = changelog_entry_header(podspec_version)
  changelog = changelog.sub(entry_header, "#{entry_header}\n- The minimum OS version required is now iOS #{new_min_os_version}.")
  # Write the changes
  write_changelog(changelog)
  modified_files.append(CHANGELOG_PATH)
end

# Output the list of modified files
puts modified_files.join(' ')
