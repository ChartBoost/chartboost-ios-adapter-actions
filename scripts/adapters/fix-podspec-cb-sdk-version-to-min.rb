# Updates the podspec by fixing the Chartboost SDK dependency version to the minimum compatible with the adapter.

require_relative 'common'

# Read the podspec file
podspec = read_podspec()

# Remove the "~>" in the podspec, keeping everything else the same (capture groups 1 and 2).
# This turns something like: spec.dependency 'ChartboostMediationSDK', '~> 4.0'
# into: spec.dependency 'ChartboostMediationSDK', '4.0'
podspec = podspec.sub(PODSPEC_CB_SDK_REGEX(), "\\1\\2")

# Write the changes
write_podspec(podspec)
