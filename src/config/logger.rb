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
  LOGGER.warn(msg)
end
