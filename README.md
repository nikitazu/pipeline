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

    require 'pipeline/http_pipe'
    
    x = Pipeline::HttpPipe.new
    x.source.add "http://somesite/some-cool-picture.jpg"
    x.config[:filename] = "my-cool-picture.jpg"
    x.config[:path] = "/tmp/downloads"
    x.execute

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
