# Updates the copyright header in all source files if outdated.

require_relative 'common'
require 'tempfile'

EMPTY_LINES_AT_BEGINNING_OF_FILE_REGEX = /\A(\n|\s)*/

# Keep a list of modified files to output at the end
modified_files = []

copyright_notice = SOURCE_FILE_COPYRIGHT_NOTICE()

# Iterate over all the files in the source directory
for_all_source_files do |file_path, contents|
  # Skip if file already has the copyright header
  if contents.start_with?(copyright_notice)
    next
  else
    tmp = Tempfile.new("tmp")
    begin
      if contents.start_with?("//")
          # If the file starts with a comment block, replace it with the copyright header
          tmp.puts contents.sub(COMMENT_BLOCK_AT_BEGINNING_OF_FILE_REGEX, copyright_notice)
      else
          # If there's no comment at the top just insert the copyright header,
          # removing all the extra empty lines at the beginning of the file first.
          tmp.puts copyright_notice + contents.sub(EMPTY_LINES_AT_BEGINNING_OF_FILE_REGEX, "")
      end

      # Replace the original file with the new one
      FileUtils.mv(tmp.path, file_path)
      modified_files.append(file_path)
    ensure
      tmp.close
      tmp.unlink
    end
  end
end

# Output the list of modified files
puts modified_files.join(' ')
