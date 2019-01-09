require "bundler"
Bundler.setup

require "composite_logging"
require "minitest/autorun"

require "pry"

Bundler.require(:test)
