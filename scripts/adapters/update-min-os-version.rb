# Updates the adapter minimum OS version based on the partner SDK minimum.

require_relative 'common'
require 'json'
require 'open3'

# Function to obtain the min OS version info from the partner podspec
def min_os_version(pod_name, pod_version)
  # Attempt to add the trunk repo explicitly
  stdout_str, stderr_str, status = Open3.capture3('pod', 'repo', 'add', 'trunk', 'https://github.com/CocoaPods/Specs.git')
  unless status.success?
    abort "`pod repo add trunk` error: #{stdout_str} #{stderr_str}"
  end

  # Update the pod repos to ensure the latest info is available
  stdout_str, stderr_str, status = Open3.capture3('pod', 'setup')
  unless status.success?
    abort "`pod setup` error: #{stdout_str} #{stderr_str}"
  end

  stdout_str, stderr_str, status = Open3.capture3('pod', 'repo', 'list')
  abort "`pod repo list` output: #{stdout_str} #{stderr_str}"

  stdout_str, stderr_str, status = Open3.capture3('pod', 'repo', 'update')
  unless status.success?
    abort "`pod repo update` error: #{stdout_str} #{stderr_str}"
  end

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

  # Read the changelog file
  changelog = read_changelog()
  # Add a note to the corresponding entry
  entry_header = changelog_entry_header(podspec_version)
  changelog = changelog.sub(entry_header, "#{entry_header}\n- The minimum OS version required is now iOS #{partner_min_os_version}.")
  # Write the changes
  write_changelog(changelog)
  modified_files.append(CHANGELOG_PATH)
end

# Output the list of modified files
puts modified_files.join(' ')
