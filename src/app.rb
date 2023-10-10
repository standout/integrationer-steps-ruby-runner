# frozen_string_literal: true

require 'json'
require 'open3'
require 'stringio'

# RubyEvaluator
class RubyEvaluator
  NOTIFY_EXIT_CODE = 101
  NOTIFY_RETRYABLE_EXIT_CODE = 102

  def initialize(event)
    @event = event
  end

  def evaluate
    stdin, stdout, stderr, wait_thr = Open3.popen3(*command)

    stdin.write(stdin_content)
    stdin.close

    stdout_content = stdout.read
    stdout.close

    stderr_content = stderr.read
    stderr.close

    exit_code = wait_thr.value.exitstatus.to_i

    {
      data: exit_code == 1 ? stderr_content : stdout_content,
      exit_code: special_exit_code(exit_code, stderr_content)
    }
  end

  private

  def special_exit_code(exit_code, stderr_content)
    return exit_code unless exit_code == 1
    return NOTIFY_EXIT_CODE if stderr_content.include?('NotifyOrganizationError')
    return NOTIFY_RETRYABLE_EXIT_CODE if stderr_content.include?('NotifyOrganizationRetryableError')

    exit_code
  end

  def stdin_content
    {
      code: @event['code'],
      fields: @event['fields'],
      account: @event['account']
    }.to_json
  end

  def command
    ['ruby', '-W0', '-r/home/runner/runner.rb', '-e', 'eval(RUNNER_CODE)']
  end
end

# Handler
class Handler
  def self.process(event: {})
    old_stdout = $stdout.dup

    $stdout = StringIO.new

    eval_result = RubyEvaluator.new(event).evaluate

    $stdout = old_stdout

    response_message('success', eval_result[:data], eval_result[:exit_code])
  rescue SystemExit => e
    response_message('success', '{}', e.status)
  end

  def self.response_message(result, data, exit_code)
    puts JSON.dump({ 'result': result, 'data': parse_data(data), 'exit_code': exit_code })
  end

  def self.parse_data(data)
    JSON.parse(data)
  rescue JSON::ParserError
    data.respond_to?(:strip) ? data.strip : data
  end
end
