# frozen_string_literal: true

require 'json'

class NotifyOrganizationError < StandardError; end
class NotifyOrganizationRetryableError < StandardError; end

stdin = ''

while s = (ARGV.shift or (!STDIN.tty? and STDIN.gets))
  stdin += s
end

begin
  RUNNER_INPUT = JSON.parse(stdin)
rescue JSON::ParserError
  RUNNER_INPUT = {}.freeze
end

RUNNER_CODE = RUNNER_INPUT.fetch('code', nil) || JSON.parse(ENV.fetch('RUNNER_CODE', '{}'))
FIELDS = RUNNER_INPUT.fetch('fields', nil) || JSON.parse(ENV.fetch('RUNNER_FIELDS', '{}'))
ACCOUNT = RUNNER_INPUT.fetch('account', nil) || JSON.parse(ENV.fetch('RUNNER_ACCOUNT', '{}'))
