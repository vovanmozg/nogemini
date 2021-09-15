require 'logger'
LOGGER = Logger.new('logfile.log')
LOGGER.level = Logger::ERROR

def debug(msg)
  LOGGER.debug(msg)
end