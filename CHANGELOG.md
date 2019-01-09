## 2.0.0 (2019-01-09)

Upgrade gem to work with Ruby 2.5.3

BREAKING CHANGE: This update will break older versions of Ruby.

## 1.1.0 (2015-12-17)

Add ability to pass in additional logger attributes, such as a log level.

## 1.0.0 (2014-08-05)

Log to multiple destinations with the Ruby logger. There are many logging gems out there, but we didn't find one with the combination of features that we wanted so we wrote our own.

composite_logging supports:

  - Logging to multiple locations, for example the console and a daily log file.
  - Customizable formatting. See pretty colors and concise timestamps on the console while writing full dates and times to a log file with ANSI codes stripped out.
  - Tags (aka nested diagnostic context or NDC). Easily identify which method, thread, etc. is responsible for a log entry.
  - Thread-safe silencing. Prevent specific sections of code from writing to the log.
Simple configuration in explicit Ruby code or using a builder DSL.
