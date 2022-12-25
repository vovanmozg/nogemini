require 'logger'
# TODO: Use arguments to pass LOG_OUT and LOG_LEVEL

LOGGER = Logger.new(
  ENV['LOG_OUT'] == 'STDOUT' ? STDOUT : 'logfile.log',
  level: ENV['LOG_LEVEL'] || 'ERROR'
)

def debug(msg)
  LOGGER.debug(msg)
end

def info(msg)
  LOGGER.info(msg)
end

def warning(msg)
  LOGGER.warn(msg.red)
end

def error(msg)
  LOGGER.error(msg.red)
end


if LOGGER.level == Logger::DEBUG
  set_trace_func proc { |event, file, line, id, binding, classname|
    if event == 'call'
      if file =~ %r{/nogemini/}
        debug "#{classname.to_s.strip}".gray + ".#{id.to_s.strip}".yellow
      end
    end
  }
end
