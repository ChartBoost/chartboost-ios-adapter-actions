# Validates all source files checking that they have the proper copyright header.

require_relative 'common'

copyright_notice = SOURCE_FILE_COPYRIGHT_NOTICE()

# Iterate over all the files in the source directory
for_all_source_files do |file_path, contents|
  # Fail some file does not start with the copyright notice
  abort "Validation failed: #{file_path} does not have a proper copyright notice header." unless contents.start_with?(copyright_notice)
end
