# development specific requirements
require 'better_errors'
require 'pry-debugger'

use BetterErrors::Middleware
BetterErrors::Middleware.allow_ip! '192.168.2.100'
BetterErrors.application_root = __dir__
