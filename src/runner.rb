# frozen_string_literal: true

require 'json'
require 'base64'
require 'ostruct'

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

def parse_input(runner_input, environment, key)
  caps_key = "RUNNER_#{key.upcase}"
  base64_key = "#{caps_key}_BASE64"

  value = runner_input.fetch(key, nil)
  return value unless value.nil?

  value = environment.fetch(caps_key, nil)
  return JSON.parse(value) unless value.nil?

  value = environment.fetch(base64_key, nil)
  return {} if value.nil?

  decoded_value = Base64.decode64(value)
  decoded_value.to_s == '' ? {} : JSON.parse(decoded_value)
end

RUNNER_CODE = parse_input(RUNNER_INPUT, ENV, 'code')
FIELDS = parse_input(RUNNER_INPUT, ENV, 'fields')
ACCOUNT = parse_input(RUNNER_INPUT, ENV, 'account')
