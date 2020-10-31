require 'json'

stdin = ''

while s=(ARGV.shift or (!STDIN.tty? and STDIN.gets) )
  stdin += s
end

RUNNER_INPUT = JSON.parse(stdin)
RUNNER_CODE = RUNNER_INPUT.fetch('code', '')
FIELDS = RUNNER_INPUT.fetch('fields', {})

