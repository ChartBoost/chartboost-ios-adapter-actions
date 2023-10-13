# Validates all source files checking that they have the proper copyright header.

require_relative 'common'

copyright_notice = SOURCE_FILE_COPYRIGHT_NOTICE()

# Iterate over all the files in the source directory
for_all_source_files do |file_path, contents|
  # Fail some file does not start with the copyright notice
  unless contents.start_with?(copyright_notice)
    current_header_match = contents.match(COMMENT_BLOCK_AT_BEGINNING_OF_FILE_REGEX)
    if current_header_match
      current_header = "Found:\n#{current_header_match.to_s}"
    else
      current_header = "First line:\n#{contents.lines.first}"
    end
    abort "Validation failed: #{file_path} does not have a proper copyright notice header.\nExpected:\n#{copyright_notice}#{current_header}"
  end
end
