# Runs all tests in this directory.

current_script = File.basename(__FILE__)

Dir.glob("*.rb").each do |script|
  next if script == current_script # Skip the current script to avoid an infinite loop

  puts "Running: #{script}"
  load script
end
