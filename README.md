# CompositeLogging

Log to multiple destinations with the Ruby logger. There are many logging gems out there, but we didn't find one with the combination of features that we wanted so we wrote our own.

`composite_logging` supports:

1. Logging to multiple locations, for example the console and a daily log file.
1. Customizable formatting. See pretty colors and concise timestamps on the console while writing full dates and times to a log file with ANSI codes stripped out.
1. Tags (aka nested diagnostic context or NDC). Easily identify which method, thread, etc. is responsible for a log entry.
1. Thread-safe silencing. Prevent specific sections of code from writing to the log.
1. Simple configuration in explicit Ruby code or using a builder DSL.

For a bit more history, see the [blog post](http://tech.patientslikeme.com/2014/08/05/yet-another-logging-gem.html).

## Configuring the logger

Here's an example of configuring a logger using the builder DSL. The resulting logger writes to two locations: standard output and a file. Standard output is in color and doesn't show the date. The log file includes both date and time.

```ruby
logger = CompositeLogging.build do
  level Logger::DEBUG

  logger do
    output          STDOUT
    formatter       CompositeLogging::ColorFormatter
    datetime_format "%T"
  end

  logger MyCustomTaggedLogger do
    output          "./log/myapp.log"
    formatter       MyCustomFormatter
    datetime_format "%F %T"
  end

  logger MyLoggerWithErrorLevel do
    output          errors.log
    formatter       CompositeLogging::Formatter
    level           Logger::ERROR
    datetime_format "%F %T"
    decolorize      true
  end
end
```

## Writing to the log

`CompositeLogger` inherits from the standard `Logger` class, so use it just as you would a `Logger`:

```ruby
logger.info "Starting"
things.each do |t|
	process_thing(t) or logger.error "Could not process thing #{t}"
end
logger.info "Done"
```

```
08:28:23 [INFO ] Starting
08:28:26 [ERROR] Could not process thing 5
08:28:27 [ERROR] Could not process thing 9
08:28:32 [INFO ] Done
```

### Tagged logging

When you have several threads processing different types of things, it's helpful to know which one is talking.

```ruby
[:rabbit, :pony].each do |type|
  Thread.new do
    logger.tagged type do
      logger.info "Starting"
      things[type].each do |t|
        process_thing(t) or logger.error "Could not process thing #{t}"
      end
      logger.info "Done"
    end
  end
end
```

```
08:35:23 [INFO ] [rabbit] Starting
08:35:23 [INFO ] [pony] Starting
08:35:26 [ERROR] [rabbit] Could not process thing 2
08:35:32 [INFO ] [rabbit] Done
08:35:33 [ERROR] [pony] Could not process thing 9
08:35:33 [INFO ] [pony] Done
```

### Silencing

Sometimes you want to prevent logging in a specific section of code. For example, we use the [Sequel](http://sequel.rubyforge.org) gem and configure it to log every database query at the DEBUG level. There are a few places where we run the same query thousands of times (with different parameters), which makes it hard to read the log file.

```ruby
logger.info "Starting"
DB[:things].each do |t|
  logger.silence do
    DB[:things].where(id: t.id).update(processed: true)
  end
end
logger.info "Done"
```

```
08:53:13 [INFO ] Starting
08:53:13 [DEBUG] (0.104939s) SELECT * FROM "things"
08:55:17 [INFO ] Done
```

## Contributing

1. Fork it ( http://github.com/patientslikeme/composite_logging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
