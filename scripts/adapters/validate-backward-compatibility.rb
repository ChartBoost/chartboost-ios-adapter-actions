# Validates that the adapter remains backward-compatibile with the first minor version of the CB SDK major series.

require_relative 'common'

# 1. Parse arguments
abort "Missing argument. Requires: allow-warnings." unless ARGV.count == 1
allow_warnings = ARGV[0]

# 2. Skip if the CB SDK major version digit is 0.
# Retrocompatibility is not required for 0.x versions.
if podspec_cb_sdk_version().start_with?("0.")
  exit
end

# 3. Fix the CB SDK version in the podspec to the lowest one compatible with the adapter.
# Read the podspec file
podspec = read_podspec()
# Remove the "~>" in the podspec, keeping everything else the same (capture groups 1 and 2).
# This turns something like: spec.dependency 'ChartboostMediationSDK', '~> 4.0'
# into: spec.dependency 'ChartboostMediationSDK', '4.0'
podspec = podspec.sub(PODSPEC_CB_SDK_REGEX(), "\\1\\2")
# Write the changes
write_podspec(podspec)

# 4. Validate the podspec, optionally allowing warnings.
success = system("pod lib lint --verbose #{allow_warnings == 'true' ? '--allow-warnings' : ''}")

# 5. Discard changes made to the podspec file
`git restore #{podspec_file_path}`

# 6. Fail if podspec validation failed
abort "Backward compatibility validation failed." unless success
