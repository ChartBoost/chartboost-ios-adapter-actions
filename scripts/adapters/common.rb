# Common definitions used by other scripts.

PODSPEC_PATH_PATTERN = "*.podspec"
PODSPEC_VERSION_REGEX = /^(\s*spec\.version\s*=\s*')([0-9]+(?>\.[0-9]+){4,5})('\s*)$/
PODSPEC_NAME_REGEX = /^\s*spec\.name\s*=\s*'([^']+)'\s*$/
PODSPEC_PARTNER_REGEX = /spec\.dependency\s*'([^']+)'/
CHANGELOG_PATH = "CHANGELOG.md"
ADAPTER_CLASS_PREFIX_MEDIATION = "ChartboostMediationAdapter"
ADAPTER_CLASS_PREFIX_CORE = "ChartboostCoreConsentAdapter"
ADAPTER_CLASS_VERSION_REGEX_MEDIATION = /^(\s*let adapterVersion\s*=\s*")([^"]+)(".*)$/
ADAPTER_CLASS_VERSION_REGEX_CORE = /^(\s*(?>public)?\s*let moduleVersion\s*=\s*")([^"]+)(".*)$/
SOURCE_DIR_PATH = "./Source"
SOURCE_FILE_EXTENSIONS = ['.h', '.m', '.swift']
SOURCE_FILE_COPYRIGHT_NOTICE = "// Copyright 2022-#{Time.now.year} Chartboost, Inc.\n//\n// Use of this source code is governed by an MIT-style\n// license that can be found in the LICENSE file.\n\n"

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
  path = Dir.glob("#{SOURCE_DIR_PATH}/#{partner_name}Adapter.swift").first
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
