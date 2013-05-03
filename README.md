# Pipeline

A bunch of pipes to connect, they can
load files from uris, archive and send
them via email.

## Installation

Add this line to your application's Gemfile:

    gem 'pipeline'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipeline


## Testing

    # unit testing
    $ bundle exec rspec spec
    
    # cli testing
    $ bundle exec cucumber features


## Usage

Http example
```ruby
require 'pipeline/http_pipe'
    
x = Pipeline::HttpPipe.new
x.add_observer Pipeline::ConsoleLogger.new # optional, or make your custom logger
x.source.add "http://somesite/some-cool-picture.jpg"
x.config[:filename] = "my-cool-picture.jpg" # optional
x.config[:path] = "/tmp/downloads" # optional
x.config[:ensure_safe_filenames] = 'no' # optional (by default 'yes')
x.execute
```

7-zip example
```ruby
require 'pipeline/zip_seven_pipe'

x = Pipeline::ZipSevenPipe.new
x.add_observer Pipeline::ConsoleLogger.new # optional, or make your custom logger
x.source.add "/path/to/my/big/file.avi"
x.config[:part_size_mb] = "4" # optional
x.config[:zip_binary] = "/usr/bin/7za" # optional
x.execute
```

E-mail example

    $ echo mylogin@gmail.com >~/.happy-clerk/email.login
    $ echo mypassword >~/.happy-clerk/email.password
    
```ruby
require 'pipeline/email_pipe'

x = Pipeline::EmailPipe.new
x.add_observer Pipeline::ConsoleLogger.new # optional, or make your custom logger
x.source.add "/tmp/hclerk/air.mp3.7z.d/air.mp3.7z.001"
x.source.add "/tmp/hclerk/air.mp3.7z.d/air.mp3.7z.002"
x.config[:to] = 'myfriend@xmail.com' # required
x.execute
```

Line example
```ruby
require 'pipeline/line'
require 'pipeline/http_pipe'
require 'pipeline/zip_seven_pipe'
require 'pipeline/email_pipe'

line = Pipeline::Line.new
line.add_observer Pipeline::ConsoleLogger.new # optional, or make your custom logger
line.add Pipeline::HttpPipe.new
line.add Pipeline::ZipSevenPipe.new
line.add Pipeline::EmailPipe.new, :to => 'nikitazu@gmail.com'

line.source.add "http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download"
line.execute
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

1. http pipe - maybe write ' ' as '_' in filename?

## Will not do
1. http pipe - try to detect filename from http response headers
