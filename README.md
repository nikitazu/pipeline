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

## Usage

Http example
```ruby
require 'pipeline/http_pipe'
    
x = Pipeline::HttpPipe.new
x.source.add "http://somesite/some-cool-picture.jpg"
x.config[:filename] = "my-cool-picture.jpg"
x.config[:path] = "/tmp/downloads"
x.execute
```

7-zip example
```ruby
require 'pipeline/zip_seven_pipe'

x = Pipeline::ZipSevenPipe.new
x.source.add "/path/to/my/big/file.avi"
x.config[:part_size_mb] = "4"
x.config[:zip_binary] = "/usr/bin/7za"
x.execute
```

E-mail example
```ruby
# todo
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Todo

1. http pipe - try to detect filename from uri
2. http pipe - try to detect filename from http response headers
3. email pipe - implement
4. line - implement line connecting pipes
