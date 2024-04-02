# Updates the adapter minimum OS version based on the partner SDK minimum.

require_relative 'common'
require 'json'

# Function to obtain the min OS version info from the partner podspec
def min_os_version(pod_name, pod_version)
  # Use the `pod spec cat` command to get the podspec as JSON
  podspec_json = `pod spec cat #{pod_name} --version=#{pod_version}`
  podspec = JSON.parse(podspec_json)
  
  # Extract the platform information; assuming iOS here
  min_os_version = podspec['platforms']['ios']
  
  # Return the version string
  min_os_version
end

# Parse the partner version string from the arguments
abort "Missing argument. Requires: partner version." unless ARGV.count == 1
partner_version = ARGV[0]

# Obtain the min OS versions for the current adapter and the desired partner version
partner_min_os_version = min_os_version(podspec_partner_sdk_name(), partner_version)
current_adapter_version = podspec_min_os_version()

# Keep a list of modified files to output at the end
modified_files = []

# Update adapter files with the new min OS version based on the partner if it's different from the current one.
if partner_min_os_version != current_adapter_version
  # Read the podspec file
  podspec = read_podspec()
  # Replace the min OS version string (capture group 2), keeping everything else the same (capture groups 1 and 3)
  podspec = podspec.sub(PODSPEC_MIN_OS_VERSION_REGEX, "\\1#{partner_min_os_version}\\3")
  # Write the changes
  write_podspec(podspec)
  modified_files.append(podspec_file_path)

  # Read the readme file
  readme = read_readme()
  # Replace the min OS version string (capture group 2), keeping everything else the same (capture groups 1 and 3)
  readme = readme.sub(README_MIN_OS_VERSION_REGEX, "\\1#{partner_min_os_version}\\3")
  # Write the changes
  write_readme(readme)
  modified_files.append(readme_file_path)
end

# Output the list of modified files
puts modified_files.join(' ')
