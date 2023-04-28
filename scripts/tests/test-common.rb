# Common definitions used by test scripts.

# Validates a script by executing it with some inputs and checking that the exit status matches the expected value.
def test(script, inputs, exitstatus)
  input_args = inputs.map { |input| "'#{input}'" }.join(' ')
  `ruby #{script} #{input_args}`
  if $?.exitstatus != exitstatus
    abort "Test failure - inputs: #{input_args}, result: #{$?.exitstatus}, expected: #{exitstatus}"
  end
end
