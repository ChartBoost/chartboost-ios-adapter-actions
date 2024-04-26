# Common definitions used by other scripts.

COMMENT_BLOCK_AT_BEGINNING_OF_FILE_REGEX = /\A(?:(?>\/\/[^\n]*\n)+(?>\n?))/
PODSPEC_CB_SDK_REGEX_CORE = /(spec\.dependency\s*'ChartboostCoreSDK',\s*')\~>\s*(\d+\.\d+(\.\d+)?')/
PODSPEC_CB_SDK_REGEX_MEDIATION = /(spec\.dependency\s*'ChartboostMediationSDK',\s*')\~>\s*(\d+\.\d+(\.\d+)?')/
PODSPEC_PATH_PATTERN = "*.podspec"
PODSPEC_VERSION_REGEX = /^(\s*spec\.version\s*=\s*')([0-9]+(?>\.[0-9]+){4,5})('\s*)$/
PODSPEC_NAME_REGEX = /^\s*spec\.name\s*=\s*'([^']+)'\s*$/
PODSPEC_MIN_OS_VERSION_REGEX = /^(\s*spec\.ios\.deployment_target\s*=\s*')([0-9]+(?>\.[0-9]+){0,2})('\s*)$/
PODSPEC_PARTNER_REGEX = /spec\.dependency\s*'([^']+)'/
CHANGELOG_PATH = "CHANGELOG.md"
CHANGELOG_ENTRY_HEADER_PREFIX = "###"
ADAPTER_CLASS_PREFIX_MEDIATION = "ChartboostMediationAdapter"
ADAPTER_CLASS_PREFIX_CORE = "ChartboostCoreConsentAdapter"
ADAPTER_CLASS_VERSION_REGEX_MEDIATION = /^(\s*let adapterVersion\s*=\s*")([^"]+)(".*)$/
ADAPTER_CLASS_VERSION_REGEX_CORE = /^(\s*(?>public)?\s*let moduleVersion\s*=\s*")([^"]+)(".*)$/
README_PATH = "README.md"
README_MIN_OS_VERSION_REGEX = /^(\s*\|\s*iOS\s*\|\s*)([0-9]+(?>\.[0-9]+){0,2})(\+?\s*\|\s*)$/
SOURCE_DIR_PATH = "./Source"
SOURCE_FILE_EXTENSIONS = ['.h', '.m', '.swift']

# Returns a platform-specific ADAPTER_CLASS_PREFIX constant.
def ADAPTER_CLASS_PREFIX
  platform = ENV['CHARTBOOST_PLATFORM']
  if platform == 'Core'
    return ADAPTER_CLASS_PREFIX_CORE
  else
    # fallback to 'Mediation'
    return ADAPTER_CLASS_PREFIX_MEDIATION
  end
end

# Returns a platform-specific ADAPTER_CLASS_VERSION_REGEX constant.
def ADAPTER_CLASS_VERSION_REGEX
  platform = ENV['CHARTBOOST_PLATFORM']
  if platform == 'Core'
    return ADAPTER_CLASS_VERSION_REGEX_CORE
  else
    # fallback to 'Mediation'
    return ADAPTER_CLASS_VERSION_REGEX_MEDIATION
  end
end

# Returns a platform-specific PODSPEC_CB_SDK_REGEX constant.
def PODSPEC_CB_SDK_REGEX
  platform = ENV['CHARTBOOST_PLATFORM']
  if platform == 'Core'
    return PODSPEC_CB_SDK_REGEX_CORE
  else
    # fallback to 'Mediation'
    return PODSPEC_CB_SDK_REGEX_MEDIATION
  end
end

def SOURCE_FILE_COPYRIGHT_NOTICE
  "// Copyright #{year_of_first_remote_commit}-#{Time.now.year} Chartboost, Inc.\n//\n// Use of this source code is governed by an MIT-style\n// license that can be found in the LICENSE file.\n\n"
end

###########
# PODSPEC #
###########

# Returns the podspec contents as a string.
def read_podspec
  # Read the podspec contents
  text = File.read(podspec_file_path)
  fail unless !text.nil?

  # Return value
  text
end

# Writes a string to the podspec file.
def write_podspec(text)
  File.open(podspec_file_path, "w") { |file| file.puts text }
end

# The path to the podspec file.
def podspec_file_path
  path = Dir.glob(PODSPEC_PATH_PATTERN).first
  fail unless !path.nil?
  path
end

# Returns the podspec version value.
def podspec_version
  # Obtain the podspec
  text = read_podspec()

  # Obtain the adapter version from the podspec
  version = text.match(PODSPEC_VERSION_REGEX).captures[1]
  fail unless !version.nil?

  # Return value
  version
end

# Returns the podspec min OS version value.
def podspec_min_os_version
  # Obtain the podspec
  text = read_podspec()

  # Obtain the min OS version from the podspec
  match = text.match(PODSPEC_MIN_OS_VERSION_REGEX)
  fail unless !match.nil?
  version = match[2]

  # Return value
  return version
end

# Returns the podspec version value.
def podspec_name
  # Obtain the podspec
  text = read_podspec()

  # Obtain the name from the podspec
  name = text.match(PODSPEC_NAME_REGEX).captures.first
  fail unless !name.nil?

  # Return value
  name
end

# Returns the podspec partner SDK dependency name.
def podspec_partner_sdk_name
  # Obtain the podspec
  text = read_podspec()

  # Obtain the partner SDK name from the podspec
  partner_sdk = text.scan(PODSPEC_PARTNER_REGEX).last.first
  fail unless !partner_sdk.nil?

  # Return value
  return partner_sdk
end

# Returns the version of the Chartboost SDK dependency in the podspec.
def podspec_cb_sdk_version
  # Obtain the podspec
  text = read_podspec()

  # Obtain the Chartboost SDK version from the podspec
  match = text.match(PODSPEC_CB_SDK_REGEX())
  fail unless !match.nil?
  sdk_version = match[2]

  # Return value
  return sdk_version
end

#############
# CHANGELOG #
#############

# Returns the changelog contents as a string.
def read_changelog
  # Read the changelog contents
  text = File.read(CHANGELOG_PATH)
  fail unless !text.nil?

  # Return value
  text
end

# Writes a string to the changelog file.
def write_changelog(text)
  File.open(CHANGELOG_PATH, "w") { |file| file.puts text }
end

# Returns the changelog entry header line for a specific version.
def changelog_entry_header(version)
  "#{CHANGELOG_ENTRY_HEADER_PREFIX} #{version}"
end

#################
# ADAPTER CLASS #
#################

# Returns the main adapter class contents as a string.
def read_adapter_class
  # Read the contents
  text = File.read(adapter_class_file_path)
  fail unless !text.nil?

  # Return value
  text
end

# Writes a string to the main adapter class file.
def write_adapter_class(text)
  File.open(adapter_class_file_path, "w") { |file| file.puts text }
end

# The path to the main adapter class file.
def adapter_class_file_path
  # Obtain the partner name
  partner_name = podspec_name.delete_prefix ADAPTER_CLASS_PREFIX()

  # Obtain the Adapter file path
  path = Dir.glob("#{SOURCE_DIR_PATH}/#{partner_name}AdapterConfiguration.swift").first
  fail unless !path.nil?

  # Return value
  path
end

# Returns the partner adapter version value in the main adapter class.
def adapter_class_version
  # Obtain the adapter class
  text = read_adapter_class()

  # Obtain the adapter version from the file
  version = text.match(ADAPTER_CLASS_VERSION_REGEX()).captures[1]
  fail unless !version.nil?

  # Return value
  version
end

##########
# README #
##########

# Returns the readme file contents as a string.
def read_readme
  # Read the contents
  text = File.read(readme_file_path)
  fail unless !text.nil?

  # Return value
  text
end

# Writes a string to the readme file.
def write_readme(text)
  File.open(readme_file_path, "w") { |file| file.puts text }
end

# The path to the readme file.
def readme_file_path
  README_PATH
end

################
# SOURCE FILES #
################

# Iterates over all source files.
def for_all_source_files()
  Dir.glob("#{SOURCE_DIR_PATH}/**/*").each do |file_path|
    # Skip if not a file or if it doesn't have one of the known extensions.
    next if File.directory?(file_path)
    next unless SOURCE_FILE_EXTENSIONS.include? File.extname(file_path)

    File.open(file_path, 'r') do |file|
      contents = file.read

      # Execute the block
      yield(file_path, contents)
    end
  end
end

#######
# GIT #
#######

# Obtains the year of the first commit in the remote.
def year_of_first_remote_commit
  # Fetch from the remote repository silently
  # --unshallow is needed to make sure we fetch all the commits, since the repo may have been
  # cloned with a limited depth (shallow clone)
  `git fetch --unshallow -q origin main 2>/dev/null`

  # Extract the commit year from the oldest commit
  commit_year = `git log origin/main --reverse --format=%cd --date=format:%Y | head -1`.strip

  # Return the value
  commit_year
end
