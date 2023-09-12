# Updates the copyright header in all source files if outdated.

require_relative 'common'
require 'tempfile'

COMMENT_BLOCK_AT_BEGINNING_OF_FILE_REGEX = /^(?:(?>\/\/[^\n]*\n)+(?>\n?))/

# Keep a list of modified files to output at the end
modified_files = []

# Iterate over all the files in the source directory
for_all_source_files do |file_path, contents|
  # Skip if file already has the copyright header
  if contents.match(SOURCE_FILE_COPYRIGHT_NOTICE_CURRENT_YEAR_ONLY_REGEX)
    # No op if the copyright year is the CURRENT year
    next
  elsif contents.match(SOURCE_FILE_COPYRIGHT_NOTICE_FROM_AND_CURRENT_YEARS_REGEX)
    # No op if the copyright year is from 20XX to the CURRENT year
    next
  elsif contents.match(SOURCE_FILE_COPYRIGHT_NOTICE_FROM_YEAR_ONLY_REGEX)
    # The file starts with copyright header that contains outdated FROM year
    tmp = Tempfile.new("tmp")
    begin
      currentYearStartIndex = SOURCE_FILE_COPYRIGHT_NOTICE_TIME_SPAN_DASH_INDEX + 1
      contents.insert(SOURCE_FILE_COPYRIGHT_NOTICE_TIME_SPAN_DASH_INDEX, "-#{Time.now.year}") # add the current year
      tmp.puts contents

      # Replace the original file with the new one
      FileUtils.mv(tmp.path, file_path)
      modified_files.append(file_path)
    ensure
      tmp.close
      tmp.unlink
    end
  elsif contents.match(SOURCE_FILE_COPYRIGHT_NOTICE_FROM_AND_TO_YEARS_REGEX)
    # The file starts with copyright header that contains outdated TO year
    tmp = Tempfile.new("tmp")
    begin
      currentYearStartIndex = SOURCE_FILE_COPYRIGHT_NOTICE_TIME_SPAN_DASH_INDEX + 1
      contents[currentYearStartIndex..currentYearStartIndex+3] = "#{Time.now.year}" # replace the outdated TO year with the current year
      tmp.puts contents

      # Replace the original file with the new one
      FileUtils.mv(tmp.path, file_path)
      modified_files.append(file_path)
    ensure
      tmp.close
      tmp.unlink
    end
  else
    # The file does not start with the copyright header
    tmp = Tempfile.new("tmp")
    begin
      if contents.start_with?("//")
        # If the file starts with a comment block, replace it with the copyright header assuming this file is created this year
        tmp.puts contents.sub(COMMENT_BLOCK_AT_BEGINNING_OF_FILE_REGEX, SOURCE_FILE_COPYRIGHT_NOTICE_PART_1_OF_2_CURRENT_YEAR_ONLY + SOURCE_FILE_COPYRIGHT_NOTICE_PART_2_OF_2)
      else
        # If there's no comment at the top just insert the copyright header
        tmp.puts SOURCE_FILE_COPYRIGHT_NOTICE + contents
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
