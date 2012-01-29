require 'logger'

class OmegaLogger < Logger
  def initialize(*args)
    super
    self.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
    end
    self
  end

  def data(data)
    data.map do |key, value|
      value = '"' + value + '"' if value.is_a?(String) && value.include?(' ')
      "#{key}=#{value}"
    end.join(' ')
  end

  #
  # Log.action_status foo: bar
  #  
  # Log.run_hook_start foo: bar
  # => action=run_hook status=start foo=bar 
  #
  def method_missing(method, *args, &block)
    tokens = method.to_s.split('_')
    result = tokens.pop
    action = tokens.join('_')
    if args.first.is_a? Hash
      message = Log.data(args.first)
    else
      message = args.join(' ')
    end
    Log.log self.level, "action=#{action} status=#{result} #{message}"
  end
end
