# Restores the podspec by discarding any changes not committed to git.

require_relative 'common'

# Restore podspec
`git restore #{podspec_file_path}`
